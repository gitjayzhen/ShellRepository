if [ ! $# == 1 ];then
   echo "Usage: sh $0 image(eg:docker.qadev.com/jayzhen/docker_ana:v3.1)"
   exit
else
   image=$1
   echo 'start deploy ana'
   workpath=`pwd`
   cd $workpath/performance_ana
   sed -i "s#docker.qadev.com/jayzhen/docker_ana:.*#${image}#" docker-compose.yml
   docker stop performance_logana
   docker rm performance_logana
   docker-compose up -d
   echo 'end'
fi
