from pyspark.sql import SparkSession
from pyspark.sql.functions import sum, round
import os 


spark = SparkSession.builder.appName("Daily Revenue Computer").getOrCreate()

src_path = os.environ.get('SRC_PATH')
tgt_path = os.environ.get('TGT_PATH')

orders = spark.read.csv(f"{src_path}/orders",
                        schema="order_id INT, order_date STRING, order_customer_id INT, order_status STRING")

order_items = spark.read.csv(f"{src_path}/order_items",
                             schema=" order_item_id INT, order_item_order_id INT, order_item_product_id INT, order_item_quantity INT, order_item_subtotal FLOAT, order_item_product_price FLOAT")



daily_revenue = orders.filter("order_status IN ('COMPLETE','CLOSED')"). \
    join(order_items, orders["order_id"] ==order_items["order_item_order_id"]).\
    groupBy("order_date").\
    agg(round(sum(order_items["order_item_subtotal"]),2).alias("daily_revenue")).\
    orderBy('order_date')
    
    
daily_revenue.write.mode('overwrite').format('delta').save(f"{tgt_path}/daily_revenue", header=True)