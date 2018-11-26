echo "执行....."
 
JAR_NAME=$1
DEPLOY_JAR_PATH=/jayzhen/server/spring-cloud
cd $DEPLOY_JAR_PATH
chmod 777 $DEPLOY_JAR_PATH/$JAR_NAME
#nohup java -Xms512m -Xmx1024m -jar $JAR_NAME  --spring.profiles.active=test55 --spring.cloud.config.uri=http://192.168.18.55:8085/config-server/ >> /jayzhen/server/spring-cloud/$1.log 2>&1 &
nohup java -Xms512m -Xmx1024m -jar $JAR_NAME  --spring.cloud.config.profile=test56 --spring.cloud.config.uri=http://192.168.18.51/config-server/  >> /jayzhen/server/spring-cloud/$1.log 2>&1 &
sleep 10

echo "**********************jenkins started*************************"
