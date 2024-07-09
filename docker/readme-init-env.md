# 使用docker-chrome进行UI自动化测试

**docker-compose目录 `/qadev/odin/uts`**

## 机器安装docker（root权限的账号进行安装）

1. 查看是否已经安装docker，如果安装了`docker version`查看是否版本过低，如果满足就继续使用；不满足就卸载

```shell
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

2. 卸载后，`yum -y update`更新软件仓库
3. 查看仓库里的docker内容`yum qadev docker`
4. 仓库里有了最新的docker组件后，进行安装，可以通过执行版本安装，也可以使用最新的

```
yum install docker-ce docker-ce-cli containerd.io
```

5. 安装完了，查看一些`yum list installed | grep docker`
6. 安装完了，再看下版本对不对

```
https://docs.docker.com/engine/install/centos/
```

7. 先不要启动，修改docker的image和volumes的本地存储位置,修改（没有就新增）`/etc/docker/daemon.json`

```json
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://je5rsr46.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker


{
    "data-root":"/qadev/odin/.docker", // 文件存储地址
    "registry-mirrors":["https://je5rsr46.mirror.aliyuncs.com"]   //镜像加速器
}
```

8. 启动docker服务`systemctl start docker.service`
9. 查看下具体的docker服务信息`docekr info`,存储位置是否正确

### 制作Dockerfile

如果不需要vnc视图，可以选择普通版的docker-chrome，debug版本的chrome带有vnc服务，比较耗费资源

```text
FROM selenium/standalone-chrome-debug:2.53.1
MAINTAINER jayzhen <qadev@qadev-inc.com>

USER root

#=====
# chinese
#=====

RUN apt-get update \
        && apt-get -y install ttf-wqy-microhei ttf-wqy-zenhei \
        && apt-get clean \
```

### 制作image

```text
docker build -f ./dockerfile/chrome-zh-2.53.1  -t selenium/standalone-chrome-debug-zh:2.53.1 .
```

### docker-compose 进行编排

<https://github.com/docker/compose/releases> 查看版本
如果pip安装失败

```shell
curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
/usr/local/bin/docker-compose -version
/usr/local/bin/docker-compose up -d
```

如果想添加一个新的docker容器，就复制下面内容就行  
注意： 需要修改的是端口`ports`里的冒号前面端口是需要给uts使用的，后面的端口号docker内容的，不用改，只用改前面的端口号即可

```text
  web-c-1:
    container_name: chrome
    image: selenium/standalone-chrome-debug-zh:2.53.1
    restart: always
    dns:
      - 8.8.8.8
    ports:
      - "14444:4444"
      - "15900:5900"
    extra_hosts:
      - "wap.qadev.com:10.0.0.0"
    volumes:
      - /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime
      - /dev/shm:/dev/shm
    environment:
      - LOGSPOUT=ignore
    cpu_shares: 256
    mem_limit: 2G
```
