if [ ! $# == 3 ];then
   echo "Usage: sh $0 num user pw"
   exit
else
	num=$1
	user=$2
	pw=$3
	docker build --no-cache -t docker-ana:v${num} .
	docker tag docker-ana:v${num} docker.qadev.com/jayzhen/docker_ana:v${num} 
	docker login -u $user -p $pw  docker.qadev.com
	sudo docker push docker.qadev.com/jayzhen/docker_ana:v${num}
fi

