#!/bin/bash
Tag="Application"
MainClass="com.test.Application"
Lib="/testboot/test/lib/"
Log="/testboot/test/run.log"
JVM="-server -Xms128m -Xmx128m -XX:PermSize=32M -XX:MaxNewSize=64m -XX:MaxPermSize=64m -Djava.awt.headless=true -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled"
echo $Tag
RETVAL="0"

# See how we were called.
function start() {
    echo  $Log 
    if [ ! -f $Log ]; then
        touch $Log
    fi
    nohup java $JVM -Dappliction=$Tag -Djava.ext.dirs=$Lib":${JAVA_HOME}/jre/lib/ext" $MainClass > $Log 2>&1 &  
    tailf $Log
}


function stop() {
    pid=$(ps -ef | grep -v 'grep' | egrep $Tag| awk '{printf $2 " "}')
    if [ "$pid" != "" ]; then      
        echo -n "boot ( pid $pid) is running" 
        echo 
        echo -n $"Shutting down boot: "
        pid=$(ps -ef | grep -v 'grep' | egrep $Tag| awk '{printf $2 " "}')
        if [ "$pid" != "" ]; then
            echo "kill boot process"
            kill -9 "$pid"
        fi
        else 
             echo "boot is stopped" 
        fi

    status
}

function status()
{
    pid=$(ps -ef | grep -v 'grep' | egrep $Tag| awk '{printf $2 " "}')
    #echo "$pid"
    if [ "$pid" != "" ]; then
        echo "boot is running,pid is $pid"
    else
        echo "boot is stopped"
    fi
}



function usage()
{
   echo "Usage: $0 {start|stop|restart|status}"
   RETVAL="2"
}

# See how we were called.
RETVAL="0"
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    reload)
        RETVAL="3"
        ;;
    status)
        status
        ;;
    *)
      usage
      ;;
esac

exit $RETVAL