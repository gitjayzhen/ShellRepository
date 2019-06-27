#!/bin/bash
source /etc/profile
DateStart=`date "+%Y-%m-%d %H:%M" -d '5 minutes ago'`
progremName="$1"
#LogFile=/root/catalina.out
LogFile=/data/log/tomcat_${progremName}/catalina.out
LogTemp=/tmp/weixin_${progremName}_catalina_min.log
FileLogContent=/tmp/weixin_${progremName}_content.log
#IP=`grep 'IPADDR' /etc/sysconfig/network-scripts/ifcfg-eth0 |awk -F= '{print $2}'`
IP=`grep 'IPADDR' /etc/sysconfig/network-scripts/ifcfg-enp1s0 |awk -F= '{print $2}'`
#egrep -wv "WARN|INFO" ${LogFile}|sed -n "/${DateStart}/,$p" > ${LogTemp}
egrep -wv "WARN|INFO" ${LogFile}|awk -v var="${DateStart}" '{if($2>=var)f=1;else f=0}f' > ${LogTemp}

ErrNum=`grep -wc 'ERROR' ${LogTemp}`
ExceptionNum=`grep -c 'Exception' ${LogTemp}`
if [[ ${ErrNum} != 0 ]] || [[ ${NullPointerExceptionNum} != 0  ]];then
	> ${FileLogContent}
	echo "${progremName}" >> ${FileLogContent}
	echo "${DateStart}" >> ${FileLogContent}
	echo "$IP" >> ${FileLogContent}
	echo "ERROR : $ErrNum" >> ${FileLogContent}
	echo "Exception : ${ExceptionNum}" >> ${FileLogContent}
	LogContent=`cat ${FileLogContent}`
	python weixin.py "${LogContent}"
fi
