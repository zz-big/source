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

logfrom=/user/zengqingyong17/task/output/etl_avro_${run_day}_zz/*
tablelocal=${TABLE_HDFS_BASE_PATH}/${ETL_AVRO_TABLE_NAME}/${month}/${day}

start_time=`date +%Y%m%d%H%M%S`
echo "=====处理日期##${run_day}====================" >> ${log_file}
echo "=====处理日期##${run_day}====================" >> ${ETL_LOG_FILE}
echo "start_time ## ${start_time}"  >> ${log_file}

load="hadoop fs -rm  -f  ${tablelocal}/*" 

echo "load ## $load" >> ${log_file}

result=`$load 2>&1`

# 获取函数返回值或者上一个命令的退出状态
re_code=$?

if [ "${re_code}" != "0" ]; then
	echo "result ## $result" >> ${log_file}
	echo "step1 ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
	exit ${re_code}
	
fi



load="hadoop fs -mv ${logfrom} ${tablelocal}" 

echo "load ## $load" >> ${log_file}

result=`$load 2>&1`

# 获取函数返回值或者上一个命令的退出状态
re_code=$?

if [ "${re_code}" != "0" ]; then
	echo "result ## $result" >> ${log_file}
	echo "step1 ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
	exit ${re_code}
	
fi

echo "end_time ## `date +%Y%m%d%H%M%S`" >> ${log_file}

echo "step1 ## $0 ## ${start_time} ## SUCCESS ## ${log_file}" >> ${ETL_LOG_FILE}






