CREATE DATABASE  IF  retail_db;

USE retail_db;

CREATE TABLE orders (
    order_id INT,
    order_date STRING,
    order_customer_id INT,  
    order_status STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';


LOAD DATA LOCAL INPATH '/home/vivek/data/retail_db/orders'
INTO TABLE orders;