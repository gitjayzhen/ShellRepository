ip=$1
user=$2
pw=$3
process=$4
duration=$5
path=$6
pid=$7
file=$process'_'$duration
filename=$path'/'$file
echo "start get mem"
sshpass -p $pw ssh -o StrictHostKeyChecking=no $user@$ip "sh ~/mem/getmem_qa.sh $process $pid"
sshpass -p $pw scp -o StrictHostKeyChecking=no -r $user@$ip:~/mem/output/top.$process.$pid.csv $path/$file'_top'
sshpass -p $pw scp -o StrictHostKeyChecking=no -r $user@$ip:~/mem/output/psaux.$process.$pid.csv $path/$file'_ps'

start=`sed -n "2,2p" $path/log.jtl |awk '{print substr($0,0,10)}'`
end=`cat $path/log.jtl|awk 'END {print}'|awk '{print substr($0,0,10)}'`
starttime=`TZ=UTC-8 date -d @$start "+%Y-%m-%d %H:%M"`
endtime=`TZ=UTC-8 date -d @$end "+%Y-%m-%d %H:%M"`

echo $starttime
echo $endtime
startline1=`grep -n "$starttime" $path/$file'_top'|head -n 1|awk -F ":" '{print $1}'`
endline1=`grep -n "$endtime" $path/$file'_top'|awk 'END {print}'|awk -F ":" '{print $1}'`
sed -n "1,1p" $path/$file'_top' >$path/$file'_top_new'
sed -n "${startline1},${endline1}p" $path/$file'_top' >>$path/$file'_top_new'
mv $path/$file'_top_new' $path/$file'_top'
# sed -i "s#,,#,DATE_TIME,#g" $path/$file'_top'

startline2=`grep -n "$starttime" $path/$file'_ps'|head -n 1|awk -F ":" '{print $1}'`
endline2=`grep -n "$endtime" $path/$file'_ps'|awk 'END {print}'|awk -F ":" '{print $1}'`
sed -n "1,1p" $path/$file'_ps' >$path/$file'_ps_new'
sed -n "${startline2},${endline2}p" $path/$file'_ps' >>$path/$file'_ps_new'
mv $path/$file'_ps_new' $path/$file'_ps'
# cat $path/$file'_ps'|awk -F "," '{print $7","$8}'>$path/$file

mkdir $path'/chart_'$file
sed "s#targetfile#$filename#g" views/charts/index.html > $path'/chart_'$file'/index.html'
echo "stop get mem"

