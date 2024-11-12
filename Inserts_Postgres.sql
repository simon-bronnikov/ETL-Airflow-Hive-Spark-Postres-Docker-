//DDL и INSERT-ы

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    gender VARCHAR(50),
    country VARCHAR(100),
    registration_date DATE
);

INSERT INTO customers (customer_id, name, age, gender, country) VALUES
(1, 'John Doe', 28, 'M', 'USA'),
(2, 'Jane Smith', 34, 'F', 'UK'),
(3, 'Michael Brown', 22, 'M', 'Canada'),
(4, 'Emily Johnson', 45, 'F', 'Australia'),
(5, 'Christopher Lee', 31, 'M', 'South Korea'),
(6, 'Sophia Garcia', 27, 'F', 'Mexico'),
(7, 'Liam Wilson', 38, 'M', 'New Zealand'),
(8, 'Olivia Davis', 19, 'F', 'USA'),
(9, 'Lucas Miller', 54, 'M', 'Germany'),
(10, 'Mia White', 29, 'F', 'Spain'),
(11, 'James Walker', 40, 'M', 'USA'),
(12, 'Ella Thompson', 33, 'F', 'Canada'),
(13, 'Benjamin Scott', 25, 'M', 'Australia'),
(14, 'Amelia Martin', 41, 'F', 'UK'),
(15, 'Henry Harris', 36, 'M', 'USA'),
(16, 'Charlotte Martinez', 23, 'F', 'France'),
(17, 'Daniel Robinson', 50, 'M', 'USA'),
(18, 'Grace Perez', 26, 'F', 'Mexico'),
(19, 'Matthew Lewis', 37, 'M', 'USA'),
(20, 'Chloe Gonzalez', 21, 'F', 'Spain');


CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10, 2),
    stock INT
);

INSERT INTO products (product_id, product_name, category, price) VALUESS
(101, 'Smartphone', 'Electronics', 599.99),
(102, 'Laptop', 'Electronics', 999.99),
(103, 'Headphones', 'Electronics', 199.99),
(104, 'Tablet', 'Electronics', 399.99),
(105, 'Camera', 'Photography', 499.99),
(106, 'Gaming Console', 'Gaming', 449.99),
(107, 'Smartwatch', 'Wearables', 299.99),
(108, 'Fitness Tracker', 'Wearables', 129.99),
(109, '4K TV', 'Electronics', 1499.99),
(110, 'Bluetooth Speaker', 'Audio', 149.99),
(111, 'Microwave Oven', 'Home Appliances', 89.99),
(112, 'Refrigerator', 'Home Appliances', 999.99),
(113, 'Washing Machine', 'Home Appliances', 749.99),
(114, 'Vacuum Cleaner', 'Home Appliances', 179.99),
(115, 'Blender', 'Home Appliances', 49.99),
(116, 'Digital Camera', 'Photography', 699.99),
(117, 'Tripod', 'Photography', 89.99),
(118, 'DSLR Lens', 'Photography', 299.99),
(119, 'Gaming Mouse', 'Gaming', 59.99),
(120, 'Keyboard', 'Computers', 79.99);

CREATE TABLE events (
    event_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    event_type VARCHAR(50), 
    event_time TIMESTAMP
);

INSERT INTO events (event_id, customer_id, product_id, event_type, event_time) VALUES
(1001, 1, 101, 'view', '2023-08-01 10:15:00'),
(1002, 2, 102, 'cart', '2023-08-01 10:30:00'),
(1003, 1, 103, 'purchase', '2023-08-01 11:00:00'),
(1004, 3, 104, 'view', '2023-08-01 11:20:00'),
(1005, 4, 105, 'purchase', '2023-08-01 12:00:00'),
(1006, 5, 106, 'view', '2023-08-01 12:30:00'),
(1007, 1, 101, 'cart', '2023-08-01 13:00:00'),
(1008, 6, 107, 'view', '2023-08-01 13:15:00'),
(1009, 7, 108, 'purchase', '2023-08-01 13:45:00'),
(1010, 1, 109, 'view', '2023-08-01 14:00:00'),
(1011, 8, 110, 'purchase', '2023-08-01 14:30:00'),
(1012, 9, 111, 'view', '2023-08-01 14:45:00'),
(1013, 10, 112, 'purchase', '2023-08-01 15:00:00'),
(1014, 11, 113, 'view', '2023-08-01 15:15:00'),
(1015, 12, 114, 'cart', '2023-08-01 15:30:00'),
(1016, 13, 115, 'purchase', '2023-08-01 15:45:00'),
(1017, 14, 116, 'view', '2023-08-01 16:00:00'),
(1018, 15, 117, 'purchase', '2023-08-01 16:30:00'),
(1019, 16, 118, 'view', '2023-08-01 16:45:00'),
(1020, 17, 119, 'purchase', '2023-08-01 17:00:00'),
(1021, 18, 120, 'view', '2023-08-01 17:30:00'),
(1022, 19, 101, 'cart', '2023-08-01 18:00:00'),
(1023, 20, 102, 'purchase', '2023-08-01 18:15:00'),
(1024, 1, 103, 'view', '2023-08-01 18:30:00'),
(1025, 2, 104, 'cart', '2023-08-01 19:00:00'),
(1026, 3, 105, 'purchase', '2023-08-01 19:15:00'),
(1027, 4, 106, 'view', '2023-08-01 19:45:00'),
(1028, 5, 107, 'purchase', '2023-08-01 20:00:00'),
(1029, 6, 108, 'view', '2023-08-01 20:30:00'),
(1030, 7, 109, 'purchase', '2023-08-01 20:45:00');

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    total_amount DECIMAL(10, 2),
    transaction_time TIMESTAMP
);

INSERT INTO transactions (transaction_id, customer_id, product_id, quantity, total_amount, transaction_time) VALUES
(5001, 1, 101, 1, 599.99, '2023-08-01 11:00:00'),
(5002, 2, 102, 1, 999.99, '2023-08-01 12:00:00'),
(5003, 4, 105, 1, 499.99, '2023-08-01 12:30:00'),
(5004, 7, 108, 1, 129.99, '2023-08-01 13:45:00'),
(5005, 10, 112, 1, 999.99, '2023-08-01 14:00:00'),
(5006, 13, 115, 2, 99.98, '2023-08-01 15:45:00'),
(5007, 15, 117, 1, 89.99, '2023-08-01 16:30:00'),
(5008, 17, 119, 3, 179.97, '2023-08-01 17:00:00'),
(5009, 20, 102, 1, 999.99, '2023-08-01 18:15:00'),
(5010, 3, 103, 2, 399.98, '2023-08-01 19:15:00'),
(5011, 5, 106, 1, 449.99, '2023-08-01 20:00:00'),
(5012, 8, 110, 1, 149.99, '2023-08-01 14:30:00'),
(5013, 9, 111, 1, 89.99, '2023-08-01 14:45:00'),
(5014, 11, 113, 1, 749.99, '2023-08-01 15:00:00'),
(5015, 6, 107, 1, 299.99, '2023-08-01 20:30:00'),
(5016, 19, 101, 1, 599.99, '2023-08-01 18:00:00');