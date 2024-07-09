ip=$1
user=$2
pw=$3
process=$4
duration=$5
name=$6
echo "stop all begin" 
jmxstart='jmeter -n -t public/files/'$name'/'$name'.jmx'
echo $jmxstart
jmxpid=`pgrep -f "$jmxstart"`
echo $jmxpid
jarstart='ApacheJMeter.jar -n -t public/files/'$name'/'$name'.jmx'
echo $jarstart
jarpid=`pgrep -f "$jarstart"`
echo $jarpid


while [ "$jmxpid" = "" ]
do
    echo $jmxpid
    jmxpid=`pgrep -f "$jmxstart"`
    sleep 1
done
kill $jmxpid 

while [ "$jarpid" = "" ]
do
    echo $jarpid
    jarpid=`pgrep -f "$jarstart"`
    sleep 1
done
kill $jarpid 

echo "stop all end"