CREATE DATABASE IF NOT EXISTS nyse_db;
USE nyse_db;
CREATE EXTERNAL TABLE IF NOT EXISTS nyse_db.nyse_stg (
    ticker STRING,
    tradedate STRING,
    open_price FLOAT,
    high_price FLOAT,
    low_price FLOAT,
    close_price FLOAT,
    volume BIGINT
) USING CSV
OPTIONS (
    PATH='/user/vivek/data/nyse'
);

REFRESH TABLE nyse_stg;

SELECT * FROM nyse_db.nyse_stg LIMIT 10;

SELECT substr(tradedate,1,6) AS trade_month, count(*) AS trade_count 
FROM nyse_stg
GROUP BY trade_month
ORDER BY trade_month;


CREATE TABLE IF NOT EXISTS nyse_daily (
    ticker STRING,
    tradedate STRING,
    open_price FLOAT,
    high_price FLOAT,
    low_price FLOAT,
    close_price FLOAT,
    volume BIGINT
) 
USING DELTA
PARTITIONED BY (trade_month STRING);


INSERT INTO TABLE nyse_daily PARTITION (trade_month)
SELECT ns.*,substr(ns.tradedate,1,6) AS trade_month
FROM nyse_stg AS ns;


SELECT trade_month, count(*) AS trade_count 
FROM nyse_daily
GROUP BY trade_month
ORDER BY trade_month;