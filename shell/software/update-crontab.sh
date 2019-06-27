#!/usr/bin/env bash

CUR_PATH=$(cd "$(dirname "$0")"; pwd)

# 要定时执行的任务
TASK_COMMAND="echo 'aaa' >> /var/cron_test"
# 要添加的crontab任务
CRONTAB_TASK="*/30 * * * * ${TASK_COMMAND}"
# 备份原始crontab记录文件
CRONTAB_BAK_FILE="${CUR_PATH}/crontab_bak"

# 创建crontab任务函数
function create_crontab()
{
    echo 'Create crontab task...'
    crontab -l > ${CRONTAB_BAK_FILE} 2>/dev/null
    sed -i "/.*${TASK_COMMAND}/d" ${CRONTAB_BAK_FILE}  # 已存在任务时会被sed删除，防止重复添加
    echo "${CRONTAB_TASK}" >> ${CRONTAB_BAK_FILE}
    crontab ${CRONTAB_BAK_FILE}

    echo 'Complete'
}

# 清除crontab任务函数
function clear_crontab(){
    echo 'Delete crontab task...'
    crontab -l > ${CRONTAB_BAK_FILE} 2>/dev/null
    sed -i "/.*${SCRIPT_NAME}/d" ${CRONTAB_BAK_FILE}
    crontab ${CRONTAB_BAK_FILE}

    echo 'Complete'
}

if [ $# -lt 1 ]; then
    echo "Usage: $0 [start | stop]"
    exit 1
fi

case $1 in
    'start' )
        create_crontab
        ;;
    'stop' )
        clear_crontab
        ;;
esac