hdfs dfs -ls /user/vivek/data/nyse

hdfs dfs -mkdir -p /user/vivek/data/nyse

hdfs dfs -put /home/vivek/data/nyse_all/nyse_data/NYSE_1998.txt.gz /user/vivek/data/nyse

hdfs dfs -rm -R -skipTrash /user/vivek/data/nyse/*

spark-sql \
  --conf spark.sql.warehouse.dir=/user/`whoami`/spark/warehouse \
  --packages io.delta:delta-spark_2.12:3.2.1 \
  --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
  --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
  -f /home/vivek/spark-sql-scripts/nyse_convertor.sql \
  -d username=`whoami` \
  --verbose
  2>/dev/null