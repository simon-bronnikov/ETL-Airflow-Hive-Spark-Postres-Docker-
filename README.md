# ETL-Airflow-Hive-Spark-Postres-Docker

# Проект ETL

Этот проект реализует процесс извлечения, трансформации и загрузки (ETL).

## Технологии

Использовались Docker образы для:
- **Hadoop-Hive**
- **Airflow**

Postgres сервер запущен локально.

## Краткое описание ETL процесса

Оркестрация процесса с помощью **Airflow**:
1. Загрузка данных из Postgres в **Spark DataFrame**.
2. Трансформация данных, создание витрины данных.
3. Загрузка данных в **Hive**.
