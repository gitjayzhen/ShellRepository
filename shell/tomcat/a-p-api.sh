#!/bin/bash
source /etc/profile
TOMCAT_HOME="/data/server/tomcat-aloan-plas-api"

echo "shutdown tomcat"
cd $TOMCAT_HOME/bin
./shutdown.sh

PID=`ps -ef | grep tomcat-aloan-plas-api |grep classpath |grep -v grep |awk '{print $2}'`
if [ "$PID"x != ""x ]; then
    echo "kill tomcat"
    kill -9 $PID
fi

#BUDIR=$TOMCAT_HOME/backup/$(date "+%Y-%m-%d_%T")
#echo "backup $BUDIR"
#mkdir $BUDIR
#mv $TOMCAT_HOME/webapps/* $BUDIR
#mv $TOMCAT_HOME/credit/* $BUDIR

echo "deploy tomcat-aloan-plas-api"
cp /data/server/workspace/pdloan-82-plas/nass-api/target/plas-api.war $TOMCAT_HOME/webapps/plas-api.war

echo "start tomcat"
cd $TOMCAT_HOME/bin
./startup.sh

#sleep 10

#mv $TOMCAT_HOME/webapps/ROOT $BUDIR/ROOT_NEW

echo "deployed success"
