#!/bin/bash
source /etc/profile
tomcatName=$1

TOMCAT_HOME=/data/server/$tomcatName


BUILD_ID=dontKillMe
echo "shutdown tomcat"
cd $TOMCAT_HOME/bin && sh shutdown.sh
sleep 10
PID=`ps -ef | grep $tomcatName |grep classpath |grep -v grep |awk '{print $2}'`
if [ "$PID"x != ""x ]; then
    echo "kill tomcat"
    kill -9 $PID
fi


echo "deploy"
cp -f $WORKSPACE/$JOB_NAME/target/*.war $TOMCAT_HOME/webapps/
echo "start tomcat"
cd $TOMCAT_HOME/bin && sh startup.sh
echo 'deployed success'
sleep 10
#chown -R dq_offline:dq_offline $TOMCAT_HOME/webapps/loan-manager
