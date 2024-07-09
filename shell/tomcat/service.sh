#!/bin/bash

basedir=`cd $(dirname $0); pwd -P`
tclog=${basedir}/logs/catalina.out

export JAVA_OPTS="-server -Xmx4g -Xms4g -XX:PermSize=256m -XX:MaxPermSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
export CATALINA_PID=${basedir}/bin/tomcat.pid
export CATALINA_OPTS="${JAVA_AGENT} -Djava.rmi.server.hostname=10.1.1.1"
export JAVA_HOME="/data/jdk"
export JRE_HOME="/data/jdk"

RETVAL=0
start(){
        checkrun
        if [ $RETVAL -eq 0 ]; then
                rm -f ${tclog}
                echo "-- Starting tomcat..."
                $basedir/bin/startup.sh
                if [ $? != 0 ]; then
                        return
                fi
                checkrun
                set tries=0
                while [ $RETVAL -eq 0 ]; do
                        let tries++
                        sleep 1
                        echo "-- Waiting ${tries}s for startup..."
                        if [ $tries -gt 60 ]; then
                                break
                        fi
                        checkrun
                done
        else
                echo "-- tomcat already running"
        fi
}

# 停止tomcat，如果是重启则带re参数，表示不查看日志，等待启动时再提示查看
stop(){
        checkrun
        if [ $RETVAL -eq 1 ]; then
                echo "-- Shutting down tomcat..."
                $basedir/bin/shutdown.sh 10 -force
                checkrun
        else
                echo "-- Tomcat is stopped"
        fi
}

status(){
        checkrun
        if [ $RETVAL -eq 1 ]; then
                echo -n "-- Tomcat ( pid "
                ps ax | grep ${basedir} | grep -v "grep" | awk '{printf $1 " "}'
                echo -n ") is running..."
                echo
        else
                echo "-- Tomcat is stopped"
        fi
        #echo "---------------------------------------------"
}

# 查看tomcat日志，带vl参数
log(){
        status
        checklog
}

# 如果tomcat正在运行，强行杀死tomcat进程，关闭tomcat
kill(){
        checkrun
        if [ $RETVAL -eq 1 ]; then
            ps ax | grep ${basedir} | grep -v "grep" | awk '{printf $1 " "}' | xargs kill -9
            status
        else
            echo "-- tomcat is not running..."
        fi
}


checkrun(){
        ps ax | grep ${basedir} | grep -v "grep"
        RETVAL=$((1-$?))
        return $RETVAL
}

# 如果是直接查看日志viewlog，则不提示输入[yes]，否则就是被stop和start调用，需提示是否查看日志
checklog(){
        echo "---------------preview log begin-------------"
        tail -n 20 ${tclog}
        echo "---------------preview log end-------------"
}

case "$1" in
start)
        start
        ;;
stop)
        stop
        ;;
restart)
        stop re
        start
        ;;
status)
        status
        #$basedir/bin/catalina.sh version
        ;;
log)
        log
        ;;
kill)
        status
        kill
        ;;
*)
        echo "Usage: $0 {start|stop|restart|status|log|kill}"
esac

