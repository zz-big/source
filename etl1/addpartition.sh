#! /bin/bash
#用于给分区表创建分区，分区目录按昨天的/month/day
# 表位置 /etltable/etl1_avro   /home/hadoop/etldata/etl1/shell/addpartition.sh >> /home/hadoop/etldata/etl1/logs/addpartition.log 2>&1
# 获取当前脚本所在位置 /home/hadoop/etldata/etl1/shell
shell_path=$(cd "$(dirname "$0")"; echo "${PWD}")
# 通过 source 或 . 来加载配置文件参数到当前脚本
. /etc/profile
. ${shell_path}/config.sh
# 获取时间
TIMESTAMP=`date -d 1' day ago' +%Y%m%d`
month=${TIMESTAMP:0:6}
day=${TIMESTAMP:6:2}
run_day=`date +%Y%m%d`

# 获取shell脚本的名称  ##/删除掉最后一个/及其前面的内容
shell_name=$0
shell_name=${shell_name##/}

# 定义log名称及输出位置
log_name="${shell_name%.sh}.log"
log_file=${ETL_BASE_PATH}/logs/${log_name}


db_name=${DB_NAME}

#avro 表名
avro_name=${ETL_AVRO_TABLE_NAME}

#orc 表名
#etl1_orc_pv_uv
orc_name1=${ETL_HOMEPAGE_ORC_TABLE_NAME1}
#etl1_orc_ip_time
orc_name2=${ETL_HOMEPAGE_ORC_TABLE_NAME2}

start_time=`date +%Y%m%d%H%M%S`
echo "=====处理日期##${run_day}====================" >> ${log_file}
echo "=====处理日期##${run_day}====================" >> ${ETL_LOG_FILE}
echo "start_time ## ${start_time}"  >> ${log_file}

sql="use ${db_name};alter table ${avro_name} add IF NOT EXISTS partition(month='${month}',day='${day}') location '${month}/${day}';"
            
echo "sql ## $sql" >> ${log_file}
            
result=`/usr/local/hive/bin/hive -e "$sql" 2>&1`
# 获取函数返回值或者上一个命令的退出状态
re_code=$?
              
if [ "${re_code}" != "0" ]; then
        echo "result ## $result" >> ${log_file}
        echo "step1 ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
        exit ${re_code}
         
fi
    
	
sql="use ${db_name};alter table ${orc_name1} add IF NOT EXISTS partition(month='${month}',day='${day}') location '${month}/${day}';"
    
echo "sql ## $sql" >> ${log_file}

result=`/usr/local/hive/bin/hive -e "$sql" 2>&1`
re_code=$?

if [ "${re_code}" != "0" ]; then
    echo "result ## $result" >> ${log_file}
    echo "step1 ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
    exit ${re_code}

fi

sql="use ${db_name};alter table ${orc_name2} add IF NOT EXISTS partition(month='${month}',day='${day}') location '${month}/${day}';"
    
echo "sql ## $sql" >> ${log_file}

result=`/usr/local/hive/bin/hive -e "$sql" 2>&1`
re_code=$?

if [ "${re_code}" != "0" ]; then
    echo "result ## $result" >> ${log_file}
    echo "step1 ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
    exit ${re_code}

fi

echo "end_time ## `date +%Y%m%d%H%M%S`" >> ${log_file}

echo "step1 ## $0 ## ${start_time} ## SUCCESS ## ${log_file}" >> ${ETL_LOG_FILE}
