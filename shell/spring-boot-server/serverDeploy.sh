#!/bin/bash
source /etc/profile 
# sh -x serverDeploy.sh test.jar 8099
# 第一：首相对旧服务进行检测关闭操作 命令行第一参数：xxx.jar
SERVICE=$1
PORT=$2
echo $SERVICE
PID=`ps -ef | grep "$SERVICE" | grep java | grep -v "$0" | grep -v "grep" | awk '{print $2}'`
# 如果启动了多个同名服务，需要使用for循环处理 for id in $PID  do done
if [ "$PID"x != ""x ]
then
kill -9 $PID
echo "killed $PID"
fi

# 第二：进行部署文件的路径操作

JAR_NAME=$1
DIRNAME=`echo $JAR_NAME | awk -F . '{print $1}' `

TARGET=/data/server/services/target
DEPLOY_JAR_PATH=/data/server/services/$DIRNAME

#!将现有的jar备份后，将新的jar包替换
if [ ! -d "$DEPLOY_JAR_PATH" ]
then
mkdir -p $DEPLOY_JAR_PATH
fi
 
if [ ! -d "$TARGET/backup" ]
then
mkdir -p $TARGET/backup
fi
 
file="/$DEPLOY_JAR_PATH/$JAR_NAME"
if [ -f "$file" ]
then
mv $file $TARGET/backup/$JAR_NAME.`date +%Y%m%d%H%M%S`
fi
sleep 4
cp -f $TARGET/$JAR_NAME $DEPLOY_JAR_PATH/$JAR_NAME

# 第三：修改jar文件操作权限，启动服务，记录日志

cd $DEPLOY_JAR_PATH
chmod 777 $DEPLOY_JAR_PATH/$JAR_NAME
nohup java -Xmx1024m -Xms512m -Xss256k -jar $JAR_NAME --spring.profiles.active=test --server.port=$PORT --logging.path=$DEPLOY_JAR_PATH >> spring.log 2>&1 &
echo 'java进程列表:'
jps -m
echo '*********************服务部署结束***********************'

