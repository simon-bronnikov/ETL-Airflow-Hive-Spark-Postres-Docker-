from pyspark.sql import SparkSession
from pyspark.sql.types import *
from pyspark.sql.functions import *
from pyspark.sql import Window

spark = SparkSession.builder\
    .config("spark.jars", "/Users/workspace/Desktop/DE/my_venv/bin/postgresql-42.7.4 20.13.35.jar")\
    .config("spark.sql.warehouse.dir", "hdfs://localhost:9010/user/hive/warehouse")\
    .config("spark.hadoop.hive.metastore.uris", "thrift://hive-metastore:9083")\
    .master("local[*]")\
    .appName("Project_1")\
    .enableHiveSupport()\
    .getOrCreate()

class Postgres:
    driver = "org.postgresql.Driver"
    url = "jdbc:postgresql://localhost:5432/de_practice"
    user = "workspace"
    password = "7352"



def read_table_pg(spark: SparkSession, name: str):
    return spark.read\
        .format("jdbc")\
        .option("driver", Postgres.driver)\
        .option("url", Postgres.url)\
        .option("user", Postgres.user)\
        .option("password", Postgres.password)\
        .option("dbtable", name)

tables_to_read = ['customers', 'products', 'events', 'transactions']

for table in tables_to_read:
    read_table_pg(spark, table)
    

customers = spark.table("customers")
products = spark.table("products")
events = spark.table("events")
transactions = spark.table("transactions")

#Checking for duplicates
if not all((
    spark.sql("""SELECT event_id
            FROM events
            GROUP BY event_id
            HAVING COUNT(*) > 1""").count() == 0,
    spark.sql("""SELECT product_id
            FROM products
            GROUP BY product_id
            HAVING COUNT(*) > 1""").count() == 0,
    spark.sql("""SELECT customer_id
            FROM customers
            GROUP BY customer_id
            HAVING COUNT(*) > 1""").count() == 0,
    spark.sql("""SELECT transaction_id
            FROM transactions
            GROUP BY transaction_id
            HAVING COUNT(*) > 1""").count() == 0)):
    raise Exception("Duplicates were found")
    

spending_rank = Window.orderBy(desc(sum("total_amount")))

customer_transactions = (
    transactions
    .groupBy("customer_id")
    .agg(
         sum("total_amount").alias("total_spent"),
         avg("total_amount").alias("avg_order_value"),
         min("transaction_time").alias("first_purchase_time"),
         max("transaction_time").alias("last_purchase_time"),
         count("transaction_id").alias("total_transactions"),
         rank().over(spending_rank).alias("spending_rank")
        )
    .select("customer_id", "total_spent", "avg_order_value", "first_purchase_time", 
            "last_purchase_time", "spending_rank", "total_transactions")
)


customer_activity = (
    customers.join(events, customers.customer_id == events.customer_id, "left")
    .groupBy(customers.customer_id.alias("customer_id"), customers.name.alias("customer_name"), "age", "gender", "country")
    .agg(
        sum(when(events["event_type"] == "view", 1).otherwise(0)).alias("total_views"),
        sum(when(events["event_type"] == "cart", 1).otherwise(0)).alias("total_cart_adds"),
        sum(when(events["event_type"] == "purchase", 1).otherwise(0)).alias("total_purchases"),
        min("event_time").alias("first_event_time"),
        max("event_time").alias("last_event_time")
    )
)


product_rank = Window.orderBy(desc(sum("total_amount")))

product_sales = (
    products.join(transactions, products.product_id == transactions.product_id, "left")
    .groupBy(products.product_id, "product_name", "category")
    .agg(
        count("transaction_id").alias("total_sales_count"),
        sum("quantity").alias("total_quantity_sold"),
        sum("total_amount").alias("total_sales_amount"),
        avg("total_amount").alias("avg_sales_amount"),
        rank().over(product_rank).alias("product_rank")   
    )
)


category_sales = ( 
    products.join(transactions, products.product_id == transactions.product_id, "left")
    .groupBy(products.category)
    .agg(
        count("transaction_id").alias("total_sales_count"),
        sum("quantity").alias("total_quantity_sold"),
        sum("total_amount").alias("total_sales_amount"),
        avg("total_amount").alias("avg_sales_amount")
    )
)


loyalty_level = (
    when(customer_transactions.total_transactions >= 10, "High")
    .when(customer_transactions.total_transactions >= 5, "Medium")
    .otherwise("low").alias("loyalty_level")
)
customer_loyalty = (
    customer_transactions
    .select("customer_id", loyalty_level)
)


data_mart_customers = (
    customer_activity.join(customer_transactions, customer_activity.customer_id == customer_transactions.customer_id, "left")
    .join(customer_loyalty, customer_activity.customer_id == customer_loyalty.customer_id, "left")
    .select(customer_activity.customer_id,
            "age",
            "gender",
            "country",
            "total_views",
            "total_cart_adds",
            "total_purchases",
            "first_event_time",
            "last_event_time",
            coalesce("total_transactions", lit(0)).alias("total_transactions"),
            coalesce("total_spent", lit(0)).alias("total_spent"),
            coalesce("avg_order_value", lit(0)).alias("avg_order_value"),
            coalesce("first_purchase_time", lit("NULL")).alias("first_purchase_time"),
            coalesce("last_purchase_time", lit("NULL")).alias("last_purchase_time"),
            coalesce("spending_rank", lit("NULL")).alias("spending_rank"), 
            "loyalty_level"
    )
)

data_mart_customers.write.mode("overwrite").partitionBy("country").saveAsTable("data_mart_customers")

spark.stop()
