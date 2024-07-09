if [ ! $# == 3 ];then
   echo "Usage: sh $0 num user pw"
   exit
else
	num=$1
	user=$2
	pw=$3
	sed -i "s#myuser#${user}#" Dockerfile
	sed -i "s#mypwd#${pw}#" Dockerfile
	docker build --no-cache -t docker_qa_platform:v${num} .
	sed -i "s#${user}#myuser#" Dockerfile
	sed -i "s#${pw}#mypwd#" Dockerfile
	docker tag docker_qa_platform:v${num} docker.qadev.com/jayzhen/docker_qa_platform:v${num} 
	docker login -u $user -p $pw  docker.qadev.com
	sudo docker push docker.qadev.com/jayzhen/docker_qa_platform:v${num}
fi

