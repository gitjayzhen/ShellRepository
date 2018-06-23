#!/bin/bash
echo '>>>Get server ipaddress :'
ip=`ifconfig eth0 | sed -n '/inet addr/p' | awk '{print $2}' | awk -F: '{print $2}'`
echo $ip

workspace='/etc/'
cd $workspace
echo '>>>current work path :' `pwd`

filelist=("redis6380.conf" "redis6381.conf" "redis6382.conf")

for f in "${filelist[@]}";do
    echo ">>>current check file is :" $f
    # cat redis6380.conf | grep '^slaveof' | awk '{print $2}'
    # cat redis6380.conf | awk '/^slaveof/{print $2}'
    oldip=$(cat $f | sed -n '/^slaveof/p' | awk '{print $2}')
    #$(awk -v tmps="$ip" '$1~/slaveof/{$2=tmps}1' $f 1<>$f)
    newip=$(cat $f | sed -n '/^slaveof/p' | awk '{print $2}')
    echo $oldip '-->' $newip
done

echo 'successed.' 
