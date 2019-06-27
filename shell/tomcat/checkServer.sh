#!/bin/bash

cur_dir=`pwd`

log=$4
#get web ngix server info
function check_avg()
{
    avg=`tail -100000 $1|awk '{print substr($NF,2,length($NF)-2)}'|awk 'BEGIN{sum=0;num=0}{sum+=$1*1000;num+=1;}END{if(num==0){print 0;}else{print int(sum/num)}}' `
    echo $avg
}
function check_qps()
{
    qps=`tail -100000 $1|awk '{print substr($4,2,length($4))}'|sort|uniq -c| awk 'BEGIN{sum=0;num=0}{sum+=$1;num+=1;}END{if(num==0){print 0;}else{print int(sum/num)}}'`
    echo $qps
}

#check_java_thread java_bin_path
function check_java_thread()
{
    pid=`ps aux| grep java|grep $1|awk '{print $2}'|head -n 1`       
    thread=`pstree $pid|awk -F'---' '{print $NF}'|awk -F'*' '{print $1}' `
    echo $thread
}

function check_jmeter_thread()
{
    pid=`ps aux| grep jmeter|grep xueqiong|grep -v check_jmeter|awk '{print $2}'|head -n 1`    
    if [ "$pid" == "" ] 
    then
        echo "0"
    else
        thread=`pstree $pid|awk -F'---' '{print $3}'|awk -F'*' '{print $1}' `
        echo $thread
    fi
}


function check_server_status()
{
    status=`tail -1 $1|awk 'BEGIN{FS="\""}{print $3}'|awk '{print $1}'`
    if [ "$status" -eq 200 ];then
       echo "1"
    else
       echo "0" 
    fi

}
function check_cpu()
{
    cpu=`vmstat 1 5|sed -n '3,$p'|awk '{x=x+$13+$14}END{print x/5.0}'`
    echo $cpu

}
function check_kpi()
{
    kpi=`tail -100000 $1|awk 'BEGIN{FS="\""}{print $3}' |awk '{print substr($1,1,1)}'|sort|uniq -c|awk 'BEGIN{a=0;b=0;c=0;d=0;all=0}{if($2==2){a+=$1;all+=$1};if($2==3){b+=$1;all+=$1};if($2==4){c+=$1;all+=$1};if($2==5){d+=$1;all+=$1}}END{if(all==0){printf("kpi:%.2f\t2xx:%.2f\t3xx:%.2f\t4xx:%.2f\t5xx:%.2f",0,0,0,0,0)}else{printf("kpi:%.2f\t2xx:%.2f\t3xx:%.2f\t4xx:%.2f\t5xx:%.2f",a*100/(a+b+c+d),a*100/all,b*100/all,c*100/all,d*100/all)}}'`
   echo $kpi
}

function check_jmeter_kpi()
{
    false_num=`grep "false" $1 |wc -l`
    true_num=`grep "true" $1 |wc -l`
    awk 'BEGIN{FS=","}{print $4}' $1 |awk '{print substr($1,1,1)}'|sort|uniq -c|awk -v false_num=$false_num -v true_num=$true_num 'BEGIN{a=0;b=0;c=0;d=0;all=0}{if($2==2){a+=$1;all+=$1};if($2==3){b+=$1;all+=$1};if($2==4){c+=$1;all+=$1};if($2==5){d+=$1;all+=$1}}END{if(all==0){printf("kpi:%.2f\t2xx:%.2f\t3xx:%.2f\t4xx:%.2f\t5xx:%.2f\n",0,0,0,0,0)}else{printf("kpi:%.2f\t2xx:%.2f\t3xx:%.2f\t4xx:%.2f\t5xx:%.2f\n",true_num*100/(true_num+false_num),a*100/all,b*100/all,c*100/all,d*100/all)}}' >> jmeter_kpi_file
    kpi=`head -n 1 $1|awk -v false_num=$false_num -v true_num=$true_num '{printf("%.2f",true_num*100/(true_num+false_num))}'`
    echo $kpi
}
 #get ngix report info   
function filter_ngix_log()
{
#$1 log_file
#$2 starttimestamp
#$3 endtimestamp
    if [ -e ngix_temp.log ];then
        rm -f ngix_temp.log
    fi
    begin_line=`grep -n "$2" $1 |head -n 1|awk 'BEGIN{FS=":"}{print $1}'`
    end_line=`grep -n "$3" $1 |head -n 1|awk 'BEGIN{FS=":"}{print $1}'`
    let line_num=$end_line-$begin_line
    head -n $end_line $1|tail -n $line_num > ngix_temp.log
}
function del_ngix_temp_log()
{
    if [ -e $1 ];then
        rm -f $1
    fi
}
function check_avg_all()
{
    if [ -e ngix_temp.log ];then
        avg=`cat ngix_temp.log|awk '{print substr($NF,2,length($NF)-2)}'|awk 'BEGIN{sum=0;num=0}{sum+=$1*1000;num+=1;}END{if(num==0){print 0;}else{print int(sum/num)}}' `
        echo $avg
    fi
}
function check_avg_all_qujian()
{
    if [ -e ngix_temp.log ];then
        echo -e "qujian\tnum\t%" >> $1
        cat ngix_temp.log|awk '{print substr($NF,2,length($NF)-2)}'|awk 'BEGIN{a=0;b=0;c=0;d=0;e=0;f=0;g=0;h=0;i=0;j=0;k=0;all=0}{t=$1*1000;if(0<=t&&t<100){a+=1;all+=1}else if(100<=t&&t<200){b+=1;all+=1}else if(200<=t&&t<300){c+=1;all+=1}else if(300<=t&&t<400){d+=1;all+=1}else if(400<=t&&t<500){e+=1;all+=1}else if(500<=t&&t<600){f+=1;all+=1}else if(600<=t&&t<700){g+=1;all+=1}else if(700<=t&&t<800){h+=1;all+=1}else if(800<=t&&t<900){i+=1;all+=1}else if(900<=t&&t<1000){j+=1;all+=1}else{k+=1;all+=1}}END{if(all==0){printf("all_req\t%d\n[0-100)\t%d\t%.4f\n[100-200)\t%d\t%.4f\n[200-300)\t%d\t%.4f\n[300-400)\t%d\t%.4f\n[400-500)\t%d\t%.4f\n[500-600)\t%d\t%.4f\n[600-700)\t%d\t%.4f\n[700-800)\t%d\t%.4f\n[800-900)\t%d\t%.4f\n[900-1000)\t%d\t%.4f\n[1000+)\t%d\t%.4f\n",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)}else{printf("all_req\t%d\n[0-100)\t%d\t%.4f\n[100-200)\t%d\t%.4f\n[200-300)\t%d\t%.4f\n[300-400)\t%d\t%.4f\n[400-500)\t%d\t%.4f\n[500-600)\t%d\t%.4f\n[600-700)\t%d\t%.4f\n[700-800)\t%d\t%.4f\n[800-900)\t%d\t%.4f\n[900-1000)\t%d\t%.4f\n[1000+)\t%d\t%.4f\n",all,a,a/all,b,b/all,c,c/all,d,d/all,e,e/all,f,f/all,g,g/all,h,h/all,i,i/all,j,j/all,k,k/all)}}' >> $1
        #echo $avg
    fi
}
function check_qps_all()
{
    if [ -e ngix_temp.log ];then
        qps=`cat ngix_temp.log|awk '{print substr($4,2,length($4))}'|sort|uniq -c| awk 'BEGIN{sum=0;num=0}{sum+=$1;num+=1;}END{print int(sum/num)}'`
        echo $qps
    fi
}

function check_kpi_all()
{
    if [ -e ngix_temp.log ];then
        cat ngix_temp.log|awk 'BEGIN{FS="\""}{print $3}' |awk '{print substr($1,1,1)}'|sort|uniq -c|awk 'BEGIN{a=0;b=0;c=0;d=0;all=0}{if($2==2){a+=$1;all+=$1};if($2==3){b+=$1;all+=$1};if($2==4){c+=$1;all+=$1};if($2==5){d+=$1;all+=$1}}END{if(all==0){printf("kpi\t%.2f\n2xx\t%.2f\n3xx\t%.2f\n4xx\t%.2f\n5xx\t%.2f\n",0,0,0,0,0)}else{printf("kpi\t%.2f\n2xx\t%.2f\n3xx\t%.2f\n4xx\t%.2f\n5xx\t%.2f\n",a*100/(a+b+c+d),a*100/all,b*100/all,c*100/all,d*100/all)}}' >> $1
       #echo $kpi
   fi
}
#  
#get db mysql info
function getProcessList()
{
    getConnectionSql="show full processlist"
    path=$1
    db_user=`grep $2 nuomi_server.conf | awk 'BEGIN{FS="\t"}{print $5}'`
    db_pwd=`grep $2 nuomi_server.conf | awk 'BEGIN{FS="\t"}{print $6}'`
    db_server=`grep $2 nuomi_server.conf | awk 'BEGIN{FS="\t"}{print $8}'`
    db_port=`grep $2 nuomi_server.conf | awk 'BEGIN{FS="\t"}{print $7}'`
    cd $path && ./mysql -u${db_user} -p${db_pwd} -h${db_server} -P${db_port} -e "${getConnectionSql}"|grep  niux > $cur_dir/processlist
}

function getConnecionSum()
{
    connections=`wc -l $cur_dir/processlist|awk -F" " '{print $1}'`
    echo "$connections"
}
  
function getConnectionState()
{
    #add status here if neccesary
    checkStatus[0]="Sleep"
    checkStatus[1]="Connect out"
    checkStatus[2]="Flushing tables"
    checkStatus[3]="Locked"
    checkStatus[4]="Sorting for group"
    checkStatus[5]="Sorting for order"
    checkStatus[6]="Updat"

    #input connection state into file
    for((i=0;i<${#checkStatus[@]};i++))
    do 
        key=${checkStatus[$i]}
        sleepConnections=`awk -F"\t*" '{print $5}'  $cur_dir/processlist |grep -c "$key" `
        echo $key"="$sleepConnections >> $1
    done
}

#computeQps /home/mysql/mysql/log/3600
function computeQps()
{
   sum1=`wc -l $1/mysql.log`
   sum2=`wc -l $1/mysql.log`
   qps=`expr $sum1 - $sum2`
   echo $qps
}

function isSlowlogGen()
{
    timeFile=`tail -n 10000 $1/slow.log~|grep 'SET timestamp' |tail -1|awk -F"=" '{print $2}'|tr -d ";" `
    if [ "$timeFile" != "" ];then
        timeNow=`date +%s`
        timeSpan=$(( $timeNow - $timeFile ))
        if (( $timeSpan < 60 ));then
            echo "1"
        else
            echo "0"
        fi
    else
        echo "0"  
    fi
}

function getSlowlogNum()
{
    if [ -f $1/slow.log~ ];then
       timeNow=`date +%s`
       timeExp=$(( $timeNow - 60 ))
       SlowlogNum=`tail -n 10000 $1/slow.log~|awk -F"=|;" '/^SET/{if($2>$timeExp) print $2}'|wc -l`
       echo $SlowlogNum
    else
       echo "0"
    fi
}

function network_recv()
{
   ntPre=`cat /proc/net/dev |grep 'lo' |awk -F ':|[ ]*' '{sum+=$3};END {print sum}'`
   sleep 1
   ntNext=`cat /proc/net/dev |grep 'lo' |awk -F ':|[ ]*' '{sum+=$3};END {print sum}'`
   let ntRecv=${ntNext}-${ntPre}
   rate=$(echo "scale=2; $ntRecv/8192" | bc)
   echo $rate
}

function network_send()
{
   ntPre=`cat /proc/net/dev |grep 'lo' |awk -F ':|[ ]*' '{sum+=$11};END {print sum}'`
   sleep 1
   ntNext=`cat /proc/net/dev |grep 'lo' |awk -F ':|[ ]*' '{sum+=$11};END {print sum}'`
   let ntTrans=${ntNext}-${ntPre}
   rate=$(echo "scale=2; $ntTrans/8192" | bc)
   echo $rate
}

function io_w()
{
 #kb/s   
    io=`iostat -d -x |sed -n '2,$p'|awk -F '[ ]*' '{sum+=$5};END {print sum}'`
    echo $io
}

function io_r()
{
 #kb/s
    io=`iostat -d -x |sed -n '2,$p'|awk -F '[ ]*' '{sum+=$4};END {print sum}'`
    echo $io 
}

function getLoad()
{
    load1=`/usr/bin/top -bcn  1 |head -n 1|awk -F "," '{print $NF}'|sed 's/ //g'`
    echo "$load1"
}


case "$1" in
    "killjmeter")
        jmeter_pid=$(ps aux|grep JMeter|awk '{if(NF>14){print $2}}')
        if [ "$jmeter_pid" != "" ]
        then
            parent_path1=`ls -l /proc/$jmeter_pid | grep "cwd"| awk 'BEGIN{FS="/"}{print $NF}'`
            cur_path1=`echo "$cur_dir"|awk 'BEGIN{FS="/"}{print $NF}'`
            if [ "$parent_path1" != "$cur_path1" ]
            then
                 echo "other"
            else
                kill $jmeter_pid
            fi
        fi
        ;;
    "startjmeter")
        chmod u+x bin/jmeter.sh
        nohup ./bin/jmeter.sh -n -t ./xueqiong.jmx -l ./xueqiong.log 2>&1 &
        ;;
    "update_counter")
        [ ! -f $2 ] && exit -1
        old_counter=`grep 'CounterConfig.start' $2|awk 'BEGIN{FS=">"}{print $2}'| awk 'BEGIN{FS="<"}{print $1}'`
        let new_counter=$old_counter+$3
        sed -i "s/CounterConfig.start.*</CounterConfig.start\">$new_counter</g" $2
    ;;
    "check_jmeter")
	source $cur_dir/server_name.conf
        rm -f jmeter_kpi_file
	rm -f jmeter_console_file
        rm -f .tmp_xueqiong.log
        tail -n 10000 xueqiong.log > .tmp_xueqiong.log
        sed -i 's/\///g' .tmp_xueqiong.log
        #grep "true" .tmp_xueqiong.log |awk 'BEGIN{FS=","}{print $3}'|sort|uniq -c > true_file

        cpu=`vmstat 1 5|sed -n '3,$p'|awk '{x=x+$13+$14}END{print x/5.0}'`
        
        echo -e "server_name\t kpi \tcur_qps\ttarget\tavg_tm\tcpu" >> jmeter_console_file 
        for server_name in ${server_names[*]}
        do
            grep $server_name .tmp_xueqiong.log > .tmp_xueqiong.log1
            cur_qps=`awk 'BEGIN{FS=","}{print int($1/1000)}' .tmp_xueqiong.log1|sort|uniq -c| awk 'BEGIN{sum=0;num=0}{sum+=$1;num+=1;}END{if(num==0){print 0;}else{print int(sum/num)}}'`
            avg_time=`awk 'BEGIN{FS=","}{print $2}' .tmp_xueqiong.log1 | awk 'BEGIN{sum=0;num=0}{sum+=$1;num+=1;}END{if(num==0){print 0;}else{print int(sum/num)}}'`
            [ -f target_qps.conf ] && target_qps=`grep $server_name target_qps.conf| awk 'BEGIN{FS="="}{print $2}'`
            [ "$target_qps" == "" ] && target_qps=0
            kpi=`check_jmeter_kpi .tmp_xueqiong.log1`
            echo -e "$server_name\t$kpi\t$cur_qps\t$target_qps\t$avg_time\t$cpu" >> jmeter_console_file 
        done
        ;;
    "check_ngix")
        #sh check_server.sh check_ngix ngix_name
        rm -f "kpi_file$2"
        [ ! -f nuomi_server.conf ] && exit 0
        log_file=`grep $2 nuomi_server.conf | awk 'BEGIN{FS="\t"}{print $5}'`
        server_port=`grep $2 nuomi_server.conf | awk 'BEGIN{FS="\t"}{print $6}'`
        avg=`check_avg $log_file`
        qps=`check_qps $log_file`
        status1=`check_server_status $log_file`
        cpu=`check_cpu`
        kpi=`check_kpi $log_file`
        echo "server_name=$2" > "kpi_file$2"
        echo "qps=$qps" >> "kpi_file$2"
        echo "$kpi" >> "kpi_file$2"
        echo "avg=$avg" >> "kpi_file$2"
        echo "status=$status1" >> "kpi_file$2"
        echo "cpu=$cpu" >> "kpi_file$2"
        network_recv=`network_recv`
        echo "network_recv=$network_recv" >> "kpi_file$2"
        network_send=`network_send`
        echo "network_send=$network_send" >> "kpi_file$2"
        ;;
    "get_ngix")
        rm -f "report_file$2"
        [ ! -f nuomi_server.conf ] && exit 0
        log_file=`grep $2 nuomi_server.conf | awk 'BEGIN{FS="\t"}{print $5}'` 
        #log_file="ngix.log"
        `filter_ngix_log $log_file $3 $4`
        avg=`check_avg_all`
        qps=`check_qps_all`
        echo "" >> "report_file$2"
        echo -e "server_name\t$2" >> "report_file$2"
        echo "" >> "report_file$2"
        echo -e "qps\t$qps" >> "report_file$2"
        echo "" >> "report_file$2"
        #echo -e "$kpi" >> "report_file$2"
        `check_kpi_all "report_file$2"`
        echo "" >> "report_file$2"
        echo -e "avg\t$avg" >> "report_file$2"
        echo "" >> "report_file$2"
        #echo -e "$qujian" >> "report_file$2"
        `check_avg_all_qujian "report_file$2"`
        echo "" >> "report_file$2"
        `del_ngix_temp_log ngix_temp.log`
        ;;
    "get_jmeter")
	source ./server_name.conf
        rm -f jmeter_report_file
        
        `cat xueqiong.log|awk -F"," -v starttime="$2" -v endtime="$3" '{t=int($1/1000);if(t>=starttime&&t<=endtime){print $0}}'>filter_xueqiong.log`
        sed -i 's/\///g' filter_xueqiong.log
        #grep "true" filter_xueqiong.log |awk 'BEGIN{FS=","}{print $3}'|sort|uniq -c > true_file
        #server_names=(bydealids map dealinfo nearbestseller nuomidata onstart orderpay sortedlist)
        for server_name in ${server_names[*]}
        do
            grep $server_name filter_xueqiong.log > server_filter_xueqiong.log
            cur_qps=`awk 'BEGIN{FS=","}{print int($1/1000)}' server_filter_xueqiong.log|sort|uniq -c| awk 'BEGIN{sum=0;num=0}{sum+=$1;num+=1;}END{if(num==0){print 0;}else{print int(sum/num)}}'`
            avg_time=`awk 'BEGIN{FS=","}{print $2}' server_filter_xueqiong.log| awk 'BEGIN{sum=0;num=0}{sum+=$1;num+=1;}END{if(num==0){print 0;}else{print int(sum/num)}}'`
            awk 'BEGIN{FS=","}{print $2}' server_filter_xueqiong.log |sort -n > server_filter_xueqiong_value
            line_num=`wc -l server_filter_xueqiong_value |awk '{print $1}'`
            let line90_num=$line_num*9
            let line90_num=$line90_num/10
            percent90_avg=`head -n $line90_num server_filter_xueqiong_value| tail -n 1`
            [ -f target_qps.conf ] && target_qps=`grep $server_name target_qps.conf| awk 'BEGIN{FS="="}{print $2}'`
            [ "$target_qps" == "" ] && target_qps=0

            echo "" >> jmeter_report_file
            echo -e "server_name\t$server_name" >> jmeter_report_file
            echo "" >> jmeter_report_file
            awk 'BEGIN{FS=","}{print $4}' server_filter_xueqiong.log |awk '{print substr($1,1,1)}'|sort|uniq -c|awk 'BEGIN{a=0;b=0;c=0;d=0;all=0}{if($2==2){a+=$1;all+=$1};if($2==3){b+=$1;all+=$1};if($2==4){c+=$1;all+=$1};if($2==5){d+=$1;all+=$1}}END{if(all==0){printf("kpi\t%.2f\n2xx\t%.2f\n3xx\t%.2f\n4xx\t%.2f\n5xx\t%.2f\n",0,0,0,0,0)}else{printf("kpi\t%.2f\n2xx\t%.2f\n3xx\t%.2f\n4xx\t%.2f\n5xx\t%.2f\n",a*100/(a+b+c+d),a*100/all,b*100/all,c*100/all,d*100/all)}}' >> jmeter_report_file
            echo "" >> jmeter_report_file
            echo -e "cur_qps\t$cur_qps" >> jmeter_report_file
            echo -e "target_qps\t$target_qps" >> jmeter_report_file
            echo "" >> jmeter_report_file
            echo -e "avg_time\t$avg_time" >> jmeter_report_file
            cat server_filter_xueqiong.log|awk 'BEGIN{FS=","}{print $2}'|awk 'BEGIN{a=0;b=0;c=0;d=0;e=0;f=0;g=0;h=0;i=0;j=0;k=0;l=0;m=0;n=0;p=0;q=0;r=0;all=0}{t=$1;if(0<=t&&t<10){a+=1;all+=1}else if(10<=t&&t<20){b+=1;all+=1}else if(20<=t&&t<30){c+=1;all+=1}else if(30<=t&&t<40){d+=1;all+=1}else if(40<=t&&t<50){e+=1;all+=1}else if(50<=t&&t<60){f+=1;all+=1}else if(60<=t&&t<70){g+=1;all+=1}else if(70<=t&&t<80){h+=1;all+=1}else if(80<=t&&t<90){i+=1;all+=1}else if(90<=t&&t<100){j+=1;all+=1}else if(100<=t&&t<150){k+=1;all+=1}else if(150<=t&&t<200){l+=1;all+=1}else if(200<=t&&t<300){m+=1;all+=1}else if(300<=t&&t<400){n+=1;all+=1}else if(400<=t&&t<500){p+=1;all+=1}else if(500<=t&&t<1000){q+=1;all+=1}else{r+=1;all+=1}}END{if(all==0){printf("all_req\t%d\n[0-10)\t%d\t%.4f\n[10-20)\t%d\t%.4f\n[20-30)\t%d\t%.4f\n[30-40)\t%d\t%.4f\n[40-50)\t%d\t%.4f\n[50-60)\t%d\t%.4f\n[60-70)\t%d\t%.4f\n[70-80)\t%d\t%.4f\n[80-90)\t%d\t%.4f\n[90-100)\t%d\t%.4f\n[100-150)\t%d\t%.4f\n[150-200)\t%d\t%.4f\n[200-300)\t%d\t%.4f\n[300-400)\t%d\t%.4f\n[400-500)\t%d\t%.4f\n[500-1000)\t%d\t%.4f\n[1000+)\t%d\t%.4f\n",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)}else{printf("all_req\t%d\n[0-10)\t%d\t%.4f\n[10-20)\t%d\t%.4f\n[20-30)\t%d\t%.4f\n[30-40)\t%d\t%.4f\n[40-50)\t%d\t%.4f\n[50-60)\t%d\t%.4f\n[60-70)\t%d\t%.4f\n[70-80)\t%d\t%.4f\n[80-90)\t%d\t%.4f\n[90-100)\t%d\t%.4f\n[100-150)\t%d\t%.4f\n[150-200)\t%d\t%.4f\n[200-300)\t%d\t%.4f\n[300-400)\t%d\t%.4f\n[400-500)\t%d\t%.4f\n[500-1000)\t%d\t%.4f\n[1000+)\t%d\t%.4f\n",all,a,a/all,b,b/all,c,c/all,d,d/all,e,e/all,f,f/all,g,g/all,h,h/all,i,i/all,j,j/all,k,k/all,l,l/all,m,m/all,n,n/all,p,p/all,q,q/all,r,r/all)}}' >> jmeter_report_file
            echo "" >> jmeter_report_file
            echo -e "90_avg\t$percent90_avg" >> jmeter_report_file
      
        done
        rm -f filter_xueqiong.log 
        rm -f server_filter_xueqiong.log
        rm -f server_filter_xueqiong_value
        ;; 
esac
