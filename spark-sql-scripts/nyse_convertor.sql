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
    PATH='/user/${username}/data/nyse'
);


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

REFRESH TABLE nyse_stg;


INSERT INTO TABLE nyse_daily PARTITION (trade_month)
SELECT ns.*,substr(ns.tradedate,1,6) AS trade_month
FROM nyse_stg AS ns;

SELECT COUNT(*) AS trade_count FROM nyse_stg;
SELECT COUNT(*) AS trade_count FROM nyse_daily;


SELECT substr(trade_month,1,4) AS trade_year, count(*) AS trade_count 
FROM nyse_daily
GROUP BY trade_year
ORDER BY trade_year;

