
#!/bin/sh
Tday=$(date +%y%m%d)
file_path="/home/jboss-5.1.0.GA/perfmon/$Tday/"
file_ser="T105PC02VM07"
file_ip="10.1.45.52"
file_time=$(date +%Y%m%d%H%M)
file_format1=".nmon"
path_log1=$file_path/$file_ser-$file_ip-$file_time$file_format1
if [ ! -d $file_path ]
then
   mkdir $file_path
   chmod 777 $file_path
fi

./nmon -t -F  $path_log1 -s 60 -c 2880 &
exit 0
