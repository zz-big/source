#! /bin/bash

#调用mapreduce，将日志清洗成avro文件

cd `dirname $0`
shell_path=`pwd`

# 通过 source 或 . 来加载配置文件参数到当前脚本
source ${shell_path}/config.sh

jar_file=${ETL_BASE_PATH}/jar/${JAR_NAME}


TIMESTAMP=`date -d 1' day ago' +%Y%m%d`
month=${TIMESTAMP:0:6}
day=${TIMESTAMP:6:2}

#定义log名称及位置
shell_name=$0
log_name="${shell_name%.sh}.log"
log_file=${ETL_BASE_PATH}/logs/${log_name}

run_day=`date +%Y%m%d`

#log输入路径
input_path=${NGINX_LOG_HDFS_BASE_PATH}/${month}/${day}
task_id=${run_day}_zz


start_time=`date +%Y%m%d%H%M%S`
echo "=====处理日期##${run_day}====================" >> ${log_file}
echo "start_time ## ${start_time}"  >> ${log_file}

hadoop_cmd="/usr/local/hadoop/bin/hadoop jar ${jar_file} etlavro -Dmymr.task.id=${task_id} -Dmymr.task.input=${input_path}"

echo "hadoop_cmd ## $hadoop_cmd" >> ${log_file}


result=`${hadoop_cmd} 2>&1`
re_code=$?

if [ "${re_code}" != "0" ]; then
	echo "result ## $result" >> ${log_file}
	echo "step1 ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
	exit ${re_code}
	
fi

echo "end_time ## `date +%Y%m%d%H%M%S`" >> ${log_file}

echo "step1 ## $0 ## ${start_time} ## SUCCESS ## ${log_file}" >> ${ETL_LOG_FILE}

