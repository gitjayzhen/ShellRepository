if [ ! $# == 3 ];then
   echo "Usage: sh $0 num user pw"
   exit
else
	num=$1
	user=$2
	pw=$3
	sed -i "s#myuser#${user}#" Dockerfile
	sed -i "s#mypwd#${pw}#" Dockerfile
	docker build --no-cache -t httprunner:v${num} .
	sed -i "s#${user}#myuser#" Dockerfile
	sed -i "s#${pw}#mypwd#" Dockerfile
	docker tag httprunner:v${num} docker.qadev.com/jayzhen/httprunner:v${num} 
	docker login -u $user -p $pw docker.qadev.com
	docker push docker.qadev.com/jayzhen/httprunner:v${num}
fi

