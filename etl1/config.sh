#! /bin/bash

# 公共的配置
#etl目录
ETL_BASE_PATH=~/etldata/etl1
#文件目录
ETL_HOMEPAGE_TABLE_NAME1_FILE=~/etldata/etl1/txt/table_file1
ETL_HOMEPAGE_TABLE_NAME2_FILE=~/etldata/etl1/txt/table_file2


#数据库
DB_NAME=db1
ETL_AVRO_TABLE_NAME=etl1_avro
ETL_HOMEPAGE_ORC_TABLE_NAME1=etl1_orc_country
ETL_HOMEPAGE_ORC_TABLE_NAME2=etl1_orc_ip



#总日志文件
ETL_LOG_FILE=~/etldata/etl1/logs/ETL_LOG_FILE.log
#jar包name
JAR_NAME=etlavro-0.0.1-SNAPSHOT-zz.jar
#hdfs上txtlog位置
NGINX_LOG_HDFS_BASE_PATH=/data/etl/nginx_log














