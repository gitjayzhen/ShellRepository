if [ ! $# == 1 ];then
   echo "Usage: sh $0 image(eg:docker.qadev.com/jayzhen/docker_report:v3)"
   exit
else
   image=$1

   echo 'start deploy'

   host=`ifconfig|grep inet|grep -v 127.0.0.1|grep -v inet6|grep -v '172.'|awk '{print $2}'|head -n 1`
   echo 'get host:'$host
   workpath=`pwd`
   sed -i "s#host_ip#$host#g" $workpath/performance_report/start.sh
   echo 'change host config to '$host
   
   cd $workpath/performance_report
   sed -i "s#docker.qadev.com/jayzhen/docker_report:.*#${image}#" docker-compose.yml
   echo 'change image to '${image}

   docker stop performance_report
   docker rm performance_report
   docker-compose up -d

   #sed -i "s#$host#host_ip#g" $workpath/performance_report/start.sh
   #echo 'change host config to 127.0.0.1'
   echo 'end'
fi
