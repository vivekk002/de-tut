hdfs dfs -rm -R /user/vivek/retail_db/daily_revenue

spark-submit \
--jars /tmp/jars/delta-storage-3.3.1.jar,/tmp/jars/delta-spark_2.12-3.3.1.jar,/tmp/jars/antlr4-runtime-4.9.3.jar \
--conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
--conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog"   \
--deploy-mode cluster   \
--conf spark.yarn.appMasterEnv.SRC_PATH=/user/vivek/retail_db   \
--conf spark.yarn.appMasterEnv.TGT_PATH=/user/vivek/retail_db   \
/home/vivek/pyspark-scripts/compute-daily-revenue.py

hdfs dfs -ls /user/vivek/retail_db/daily_revenue
