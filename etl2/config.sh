#! /bin/bash

# 公共的配置
#etl目录
ETL_BASE_PATH=~/etl
#文件目录
ETL_HOMEPAGE_TABLE_NAME1_FILE=~/etl/txt/table_home
ETL_HOMEPAGE_TABLE_NAME2_FILE=~/etl/txt/table_topic


#数据库
DB_NAME=zengqingyong17
ETL_AVRO_TABLE_NAME=etl2_avro
ETL_HOMEPAGE_ORC_TABLE_NAME1=etl2_orc_homepage
ETL_HOMEPAGE_ORC_TABLE_NAME2=etl2_orc_topic



#总日志文件
ETL_LOG_FILE=~/etl/logs/ETL_LOG_FILE.log
#jar包name
JAR_NAME=etl2_avro-0.0.1-SNAPSHOT-zz.jar
JAR_NAME1=etl2_orc_homepage-0.0.1-SNAPSHOT-zz.jar
JAR_NAME2=etl2_orc_topic-0.0.1-SNAPSHOT-zz.jar
#hdfs上txtlog位置
NGINX_LOG_HDFS_BASE_PATH=/user/hainiu/data/hainiuetl/input
#hdfs上table位置
TABLE_HDFS_BASE_PATH=/user/zengqingyong17/etl/table














