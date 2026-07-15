CREATE DATABASE IF NOT EXISTS nyse_db;
USE nyse_db;




CREATE TABLE IF NOT EXISTS nyse_daily (
    ticker STRING,
    tradedate INT,
    openprice FLOAT,
    highprice FLOAT,
    lowprice FLOAT,
    closeprice FLOAT,
    volume BIGINT
) PARTITIONED BY (trademonth INT ) 
STORED AS PARQUET;


CREATE TABLE IF NOT EXISTS nyse_stg (
    ticker STRING,
    tradedate INT,
    openprice FLOAT,
    highprice FLOAT,
    lowprice FLOAT,
    closeprice FLOAT,
    volume BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA INPATH '/user/vivek/data/nyse'
OVERWRITE INTO TABLE nyse_stg;

SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE nyse_daily PARTITION(trademonth)
SELECT ns.*,substr(tradedate,1,6) AS trademonth FROM nyse_stg AS ns;

SHOW PARTITIONS nyse_daily;