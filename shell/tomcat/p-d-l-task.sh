#!/bin/bash
source /etc/profile
TOMCAT_HOME="/data/server/tomcat-paydayloan-task"

echo "shutdown tomcat"
cd $TOMCAT_HOME/bin && sh shutdown.sh

PID=`ps -ef | grep tomcat-paydayloan-task |grep classpath |grep -v grep |awk '{print $2}'`
if [ "$PID"x != ""x ]; then
    echo "kill tomcat"
    kill -9 $PID
fi

#BUDIR=$TOMCAT_HOME/backup/$(date "+%Y-%m-%d_%T")
#echo "backup $BUDIR"
#mkdir $BUDIR
#mv $TOMCAT_HOME/webapps/* $BUDIR

echo "deploy"
cp -f /data/server/workspace/pdloan-82_pay-day-loan-task/pay-day-loan-task/target/pay-day-loan-task.war $TOMCAT_HOME/webapps/ROOT.war

echo "start tomcat"
cd $TOMCAT_HOME/bin && sh startup.sh

echo "deployed success"
