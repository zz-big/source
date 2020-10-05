#! /bin/bash

cd `dirname $0`
shell_path=`pwd`
# 通过 source 或 . 来加载配置文件参数到当前脚本
source ${shell_path}/config.sh

# 获取时间
TIMESTAMP=`date -d 1' day ago' +%Y%m%d`
month=${TIMESTAMP:0:6}
day=${TIMESTAMP:6:2}

# 获取shell脚本的名称  ##/删除掉最后一个/及其前面的内容
shell_name=$0
shell_name=${shell_name##/}


# 定义log名称及输出位置
log_name="${shell_name%.sh}.log"
log_file=${ETL_BASE_PATH}/logs/${log_name}

run_day=`date +%Y%m%d`


start_time=`date +%Y%m%d%H%M%S`
echo "=====处理日期##${run_day}====================" >> ${log_file}
echo "=====处理日期##${run_day}====================" >> ${ETL_LOG_FILE}
echo "start_time ## ${start_time}"  >> ${log_file}

load="use ${DB_NAME}; insert overwrite table ${ETL_HOMEPAGE_ORC_TABLE_NAME1} partition(month='${month}',day='${day}')  select country,substring(uptime,1,8) from ${ETL_AVRO_TABLE_NAME} where month='${month}' and day='${day}' " 

echo "load ## $load" >> ${log_file}

result=`/usr/local/hive/bin/hive -e "$load" 2>&1`

# 获取函数返回值或者上一个命令的退出状态
re_code=$?

if [ "${re_code}" != "0" ]; then
	echo "result ## $result" >> ${log_file}
	echo "step1 ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
	exit ${re_code}
	
fi



load="use ${DB_NAME}; insert overwrite table ${ETL_HOMEPAGE_ORC_TABLE_NAME2} partition(month='${month}',day='${day}')  select aip,substring(uptime,1,8) from ${ETL_AVRO_TABLE_NAME} where month='${month}' and day='${day}' " 

echo "load ## $load" >> ${log_file}

result=`/usr/local/hive/bin/hive -e "$load" 2>&1`

# 获取函数返回值或者上一个命令的退出状态
re_code=$?

if [ "${re_code}" != "0" ]; then
	echo "result ## $result" >> ${log_file}
	echo "step1 ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
	exit ${re_code}
	
fi



echo "end_time ## `date +%Y%m%d%H%M%S`" >> ${log_file}

echo "step1 ## $0 ## ${start_time} ## SUCCESS ## ${log_file}" >> ${ETL_LOG_FILE}






