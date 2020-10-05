#! /bin/bash

# 获取当前脚本所在位置 /home/hadoop/etldata/etl1/shell
shell_path=$(cd "$(dirname "$0")"; echo "${PWD}")
# 通过 source 或 . 来加载配置文件参数到当前脚本
source ${shell_path}/config.sh
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

#输入文件
#输入文件
file2=${ETL_HOMEPAGE_TABLE_NAME2_FILE}


start_time=`date +%Y%m%d%H%M%S`
echo "=====处理日期##${run_day}====================" >> ${log_file}
echo "=====处理日期##${run_day}====================" >> ${ETL_LOG_FILE}
echo "start_time ## ${start_time}"  >> ${log_file}


mysqlDBUrl="/bin/mysql -h192.168.88.195 -p3306 -uhainiu -p12345678 -Dhainiutest"
${mysqlDBUrl} <<EOF
LOAD DATA LOCAL INFILE "${file2}" INTO TABLE c17_g1_zz_topicdata FIELDS TERMINATED BY '\t';
EOF


re_code=$?
if [ "${re_code}" != "0" ]; then
	echo "result ## 导入数据错误" >> ${log_file}
	echo "step7[category] ## $0 ## ${start_time} ## FAIL ## ${log_file}" >> ${ETL_LOG_FILE}
	exit ${re_code}
	
fi

echo "end_time ## `date +%Y%m%d%H%M%S`" >> ${log_file}

echo "step1 ## $0 ## ${start_time} ## SUCCESS ## ${log_file}" >> ${ETL_LOG_FILE}
