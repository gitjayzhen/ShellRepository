#!/bin/bash
source /etc/profile
TOMCAT_HOME="/home/tomcat/tomcat7"

echo "shutdown tomcat"
cd $TOMCAT_HOME/bin && sh shutdown.sh

PID=`ps -ef | grep tomcat7 |grep classpath |grep -v grep |awk '{print $2}'`
if [ "$PID"x != ""x ]; then
    echo "kill tomcat"
    kill -9 $PID
fi

#BUDIR=$TOMCAT_HOME/backup/$(date "+%Y-%m-%d_%T")
#echo "backup $BUDIR"
#mkdir $BUDIR
#mv $TOMCAT_HOME/webapps/* $BUDIR
mv $TOMCAT_HOME/webapps/ermas.war  $TOMCAT_HOME/webapps/ermas.war.$(date "+%Y-%m-%d_%T")

echo "****** delete old codes ******"
rm -rf $TOMCAT_HOME/webapps/ermas


echo "****** deploy ermas ******"
cp -f /home/tomcat/workspace/bjtest_ermas_26/ermas-web/target/ermas-web-1.4.0.hb-SNAPSHOT.war $TOMCAT_HOME/webapps/ermas.war

echo "start tomcat"
cd $TOMCAT_HOME/bin && sh startup.sh

echo "****** deployed success ******"
