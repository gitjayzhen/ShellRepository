#!/bin/sh
Tday=$(date +%y%m%d)
file_path="/home/ap/epsvc/perfmon/$Tday/"
file_ser="T105PC02VM07"
file_ip="***"
file_time=$(date +%Y%m%d%H%M)
file_format=".nmon"
path_log=$file_path/$file_ser-$file_ip-$file_time$file_format

if [ ! -d $file_path ]
then
   mkdir $file_path
   chmod 777 $file_path
fi

../nmon -t -F  $path_log -s 10 -c 8640 & 
exit 0
