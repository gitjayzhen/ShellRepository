#!/bin/sh
#Warning:Not Modified

VAR=$#
if [ $VAR -lt 1  ]
then
	echo "[-]Please input [stop|start|restart] as parameter!"
	exit 0
fi

INPUT=$1
if [ $INPUT = "stop"  ]
then
	STATUS=`docker ps |grep houniao_jenkins | wc -l`
	if [ $STATUS -lt 1  ]
	then
		echo "[-]houniao_jenkins NOT EXIST!"
		exit 0
	else
		docker rm -f houniao_jenkins
		echo "[+]houniao_jenkins REMOVED!"
		exit 0
	fi
elif  [ $INPUT = "start"  ]
then
	STATUS=`docker ps |grep houniao_jenkins | wc -l`
	if [ $STATUS -lt 1  ]
	then
		docker run --name houniao_jenkins -d -p 8888:8080 -p 50000:50000 -v /houniao/data/jenkins:/var/jenkins_home -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai registry.houniao.net/library/jenkins:2
		echo "[+]houniao_jenkins RUNNING NOW!"
		exit 0
	else
		echo "[-]houniao_jenkins already EXIST!"
		exit 0
	fi
elif  [ $INPUT = "restart"  ]
then
	STATUS=`docker ps |grep houniao_jenkins | wc -l`
	if [ $STATUS -lt 1  ]
	then
		echo "[-]houniao_jenkins NOT EXIST! now start it only!"
		docker run --name houniao_jenkins -d -p 8888:8080 -p 50000:50000 -v /houniao/data/jenkins:/var/jenkins_home -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai registry.houniao.net/library/jenkins:2
		echo "[+]houniao_jenkins RUNNING NOW!"
		exit 0
	else
		docker rm -f houniao_jenkins
		echo "[+]houniao_jenkins REMOVED!"
		docker run --name houniao_jenkins -d -p 8888:8080 -p 50000:50000 -v /houniao/data/jenkins:/var/jenkins_home -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai registry.houniao.net/library/jenkins:2
		echo "[+]houniao_jenkins RUNNING NOW!"
		exit 0
	fi
else
echo "[-]Parameter not supported ! Please input [stop|start|restart] as parameter!"
exit 0
fi



