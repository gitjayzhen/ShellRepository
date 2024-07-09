echo 'start deploy'
host=`ifconfig|grep inet|grep -v 127.0.0.1|grep -v inet6|grep -v '172.'|awk '{print $2}'|head -n 1`
echo 'get host:'$host
workpath=`pwd`
sed -i "s#host_ip#$host#g" $workpath/jmeternode/start.sh
echo 'change host config to '$host

if [ "$host" = "10.1.1.1" ] && [ $1 = "yes" ]; then
    cd $workpath/mysql
    docker-compose build
    docker-compose up -d
fi

cd $workpath/jmeternode
docker-compose build
docker-compose up -d

sed -i "s#$host#host_ip#g" $workpath/jmeternode/start.sh
echo 'change host config to 127.0.0.1'
echo 'end'