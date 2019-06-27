#!/bin/sh
cmds=$1
echo $cmds
projectArray=("tomcat-1" "tomcat-2" "tomcat-3" "tomcat-4")
workpath=/data/server

cd $workpath || exit
if  [ "$cmds" = "start" ]; then
    for p in "${projectArray[@]}";do
        echo "${p}"/bin
        PID=`ps -ef | grep "${p}" |grep classpath |grep -v grep |awk '{print $2}'`
        if [ "${PID}" != "" ];then
            echo "Kill ${p} "
            kill -9 "${PID}"
        fi
        sh $p/bin/startup.sh
    done
fi

if [ "${cmds}" = "clean" ]; then
    for p in "${projectArray[@]}";do
        echo "${p}"/logs
        cd "${p}"/logs
        :> catalina.out || exit
        echo "clean up finished"
	cd ../..
    done
fi
