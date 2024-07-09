#!/bin/sh
path=`pwd`
[[ -d ~/mem/ ]] && 
echo "~/mem/ exist..." && 
wget "http://10.1.1.1:3334/public/mem/mem.sh" -O ~/mem/mem.sh && 
wget "http://10.1.1.1:3334/public/mem/io.sh" -O ~/mem/io.sh && 
wget "http://10.1.1.1:3334/public/mem/io2.sh" -O ~/mem/io2.sh && 
wget "http://10.1.1.1:3334/public/mem/addmem_wtt.sh" -O ~/mem/addmem_wtt.sh && 
wget "http://10.1.1.1:3334/public/mem/getmem_wtt.sh" -O ~/mem/getmem_wtt.sh && 
wget "http://10.1.1.1:3334/public/mem/getpic_wtt.sh" -O ~/mem/getpic_wtt.sh && 
wget "http://10.1.1.1:3334/public/mem/getpids_wtt.sh" -O ~/mem/getpids_wtt.sh &&  
wget "http://10.1.1.1:3334/public/mem/script/functions.sh" -O ~/mem/script/functions.sh && 
wget "http://10.1.1.1:3334/public/mem/script/diskio.create.sh" -O ~/mem/script/diskio.create.sh && 
wget "http://10.1.1.1:3334/public/mem/script/diskio.update.sh" -O ~/mem/script/diskio.update.sh && 
wget "http://10.1.1.1:3334/public/mem/script/netio.create.sh" -O ~/mem/script/netio.create.sh && 
wget "http://10.1.1.1:3334/public/mem/script/netio.update.sh" -O ~/mem/script/netio.update.sh && 
wget "http://10.1.1.1:3334/public/mem/script/cpu.create.sh" -O ~/mem/script/cpu.create.sh && 
wget "http://10.1.1.1:3334/public/mem/script/cpu.update.sh" -O ~/mem/script/cpu.update.sh && 
wget "http://10.1.1.1:3334/public/mem/script/load.create.sh" -O ~/mem/script/load.create.sh && 
wget "http://10.1.1.1:3334/public/mem/script/load.update.sh" -O ~/mem/script/load.update.sh &&  
wget "http://10.1.1.1:3334/public/mem/script/mem.create.sh" -O ~/mem/script/mem.create.sh && 
wget "http://10.1.1.1:3334/public/mem/script/mem.update.sh" -O ~/mem/script/mem.update.sh && 
ifstat -v|grep "ifstat version 1.1."|awk '{ if($0=="") print "install ifstat failed."; else print "install ifstat succeed."}' &&
chmod 777 ~/mem/script/*.sh && 
chmod 777 ~/mem/*.sh && 
exit 1

date >>$path/crontab.bak
crontab -l >>$path/crontab.bak
crontab -l | grep -v "$path/mem/mem.sh" | grep -v "$path/mem/io2.sh" >crontab.tmp
echo -e "* * * * * sleep 10; $path/mem/mem.sh >/dev/null 2>&1" >>crontab.tmp
echo -e "* * * * * sleep 20; $path/mem/mem.sh >/dev/null 2>&1" >>crontab.tmp
echo -e "* * * * * sleep 30; $path/mem/mem.sh >/dev/null 2>&1" >>crontab.tmp
echo -e "* * * * * sleep 40; $path/mem/mem.sh >/dev/null 2>&1" >>crontab.tmp
echo -e "* * * * * sleep 50; $path/mem/mem.sh >/dev/null 2>&1" >>crontab.tmp
echo -e "* * * * * sleep 60; $path/mem/mem.sh >/dev/null 2>&1" >>crontab.tmp
echo -e "*/5 * * * * $path/mem/io2.sh >/dev/null 2>&1" >>crontab.tmp
crontab crontab.tmp
rm -f crontab.tmp

wget "http://10.1.1.1:3334/public/mem.zip" -O ~/mem.zip
unzip ~/mem.zip -d .
rm -f ~/mem.zip

yum install rrdtool -y
wget http://10.1.1.1:3334/public/ifstat-1.1.tar.gz
tar xzvf ifstat-1.1.tar.gz
cd ifstat-1.1
./configure
make
make install

if [ $? -ne 0 ]; then
    echo "install ifstat failed."
else
    echo "install ifstat succeed."
fi

