#!/bin/bash
source /etc/profile
TOMCAT_HOME="/data/server/tomcat6-ImageSystem"

echo "shutdown tomcat"
cd $TOMCAT_HOME/bin && sh shutdown.sh

PID=`ps -ef | grep tomcat6-ImageSystem |grep classpath |grep -v grep |awk '{print $2}'`
if [ "$PID"x != ""x ]; then
    echo "kill tomcat"
    kill -9 $PID
fi

BUDIR=$TOMCAT_HOME/backup/$(date "+%Y-%m-%d_%T")
echo "backup $BUDIR"
mkdir -p $BUDIR
mv $TOMCAT_HOME/webapps/* $BUDIR

echo "deploy tomcat6-ImageSystem"
cp -rf /data/server/workspace/bjtest-45-ImageSystem/app $TOMCAT_HOME/webapps/ImageSystem
mkdir -p $TOMCAT_HOME/webapps/ImageSystem/xerox
echo "start tomcat"
cd $TOMCAT_HOME/bin && sh startup.sh

echo "deployed success"
