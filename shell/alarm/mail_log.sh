#!/bin/bash
source /etc/profile
DateStart=`date "+%Y-%m-%d %H:%M" -d '3 minutes ago'`
progremName=$1
LogFile=/data/log/tomcat_${progremName}/catalina.out
LogTemp=/tmp/catalina_min.log
FileLogContent=/tmp/content.log
IP=`grep 'IPADDR' /etc/sysconfig/network-scripts/ifcfg-eth0 |awk -F= '{print $2}'`
#IP=`grep 'IPADDR' /etc/sysconfig/network-scripts/ifcfg-enp1s0 |awk -F= '{print $2}'`
#egrep -wv "WARN|INFO" ${LogFile}|sed -n "/${DateStart}/,$p" > ${LogTemp}
egrep -wv "WARN|INFO" ${LogFile}|awk -v var="${DateStart}" '{if($2>=var)f=1;else f=0}f' > ${LogTemp}

ErrNum=`grep -wc 'ERROR' ${LogTemp}`
ExceptionNum=`grep -c 'Exception' ${LogTemp}`
if [[ ${ErrNum} != 0 ]] || [[ ${NullPointerExceptionNum} != 0  ]];then
	> ${FileLogContent}
	echo "${DateStart}" >> ${FileLogContent}
	echo "$IP" >> ${FileLogContent}
	echo ${progremName} >> ${FileLogContent}
	echo "ERROR : $ErrNum" >> ${FileLogContent}
	echo "Exception : ${ExceptionNum}" >> ${FileLogContent}
	echo "----------------------------------------------------" >> ${FileLogContent}
	grep -w "ERROR" ${LogTemp} |tail -10 >> ${FileLogContent} 
	echo "----------------------------------------------------" >> ${FileLogContent}
	grep -vw 'ERROR' ${LogTemp} |grep -A10 "Exception" |tail -59 >> ${FileLogContent}
	LogContent=`cat ${FileLogContent}`
	python mail.py "zhaohongyong@hou.cn,wangzhe01@hou.cn,wanglei01@hou.cn" "[重要]xloan3异常报警" "${LogContent}"
fi
