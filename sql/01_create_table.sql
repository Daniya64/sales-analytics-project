
-- Create a table to store the cleaned Superstore dataset

CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(20),
    customer_id VARCHAR(20),
    customer_name VARCHAR(60),
    segment VARCHAR(20),
    country VARCHAR(30),
    city VARCHAR(50),
    state VARCHAR(40),
    postal_code VARCHAR(5),
    region VARCHAR(20),
    product_id VARCHAR(20),
    category VARCHAR(30),
    sub_category VARCHAR(30),
    product_name VARCHAR(200),
    sales NUMERIC(12,4),
    quantity INT,
    discount NUMERIC(4,2),
    profit NUMERIC(12,4),
    order_year INT,
    order_month INT,
    profit_margin_pct NUMERIC(10,2),
    shipping_days INT
);
