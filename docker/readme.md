# UTS自动化测试平台任务机docker环境部署方案

## 本工程主要用于归集和管理各个服务器上的docker服务

### 依赖（base in linux environment）

1. python
2. docker
3. docker-compose
4. [docker-selenium](https://github.com/SeleniumHQ/docker-selenium)

## 1. 新的机器上如何部署

* 安装python（主要使用pip，版本不是很重要 >= 2，即可）
> 一般这个服务器上默认都有安装，只要有就行了，本方案主要使用pip工具，
`python -V`检查下有没有python，然后`pip list`检查下有没有pip工具

* 安装docker（这个可以只用使用yum安装，走的是qadev的镜像源，一般会得到最新版本）
提前`docker info`检查下有没有安装
>1. 这里需要注意的是linux服务器内核必须大于3.0,否则安装不上： uname -r查看
>2. 安装完成后，记得修改docker的镜像存储路径，如果默认的存储路径所在的盘符内存比较大，可以不用改（每个docker版本的改法不一样，可看官网[dockerd](https://docs.docker.com/engine/reference/commandline/dockerd/)）

`/etc/docker/daemon.json`文件，没有就创建，然后重启docker服务【建议：不开放docker api服务端口】

```
{"data-root":"/qadev/odin/.docker",
"registry-mirrors":["https://je5rsr46.mirror.aliyuncs.com"],
"hosts":[
    "unix:///var/run/docker.sock",
    "tcp://0.0.0.0:2375"
]
}
```
`service docker restart` 一般都是root用户重启，普通用户可能会有问题，可看具体服务器的表现，如果服务是root启动的，就用root重启

**注意：如果服务器上有网页前端服务，基本上都已经拥有docker环境了**

* 安装docker-compose(用于编排docker， 版本暂无要求)

`pip list`看下是否已经安装了`docker-compose`包,如果没有安装,执行命令安装`pip install docker-compose`,如果安装中间出现错误，可能是因为网速过慢或者被墙，可以使用国内镜像 `pip install -i https://mirrors.aliyun.com/pypi/simple docker-compose`

***到此基本上依赖的环境都安装完成了***

***

## 2. 设计dockerfile和docker-compose

可参考已有的机器配置

**注意命名规则**
> 每个机器都以机器的ip创建文件夹，文件夹下内容格式如下: 

```
.
└── 10.*.*.*
    ├── docker-compose.yml
    ├── dockerfile
    │   └── chrome-dbg-zh-3.141
    └── readme-wap-frontend.md
```
`docker-compose.yml` 用于设计docker实例的内容  
`dockerfile/chrome-dbg-zh-3.141` 构建镜像的镜像文件  
`readme-wap-frontend.md` 用于直观看出当前配置是哪个项目组的，还有就是文件内容用于记录需求改动

***

## GIT使用局部方式下载项目内容

+ 本地`git init`实例化下项目
+ 然后修改配置文件 `git config core.sparsecheckout true`
+ 将项目下指定的文件写入到配置文件中`echo apps/sq-82.209/* >> .git/info/sparse-checkout`
+ 然后为这个项目添加一个远程仓库`git remote add origin https://qadev@git.qadev.com/jayzhen/docker-sg-community.git`
+ 然后拉取文件`git pull origin master`

***

## 管理设计：使用portainer容器来各个机器上的容器内容

访问`http://uts.qadev-inc.com:19000`,可看到当前机器上有哪些机器或集群实例


**注意以下问题**

* 使用swarm创建集群

>1.关于manager和worker的创建  docker swarm init -h  
2.如何介入集群，如果离开和删除节点 docker swarm -h  
3.如何解散集群docker swarm leave --force

```
排空节点上的集群容器 。
docker node update --availability drain g36lvv23ypjd8v7ovlst2n3yt

主动离开集群，让节点处于down状态，才能删除
docker swarm leave

删除指定节点 （管理节点上操作）
docker node rm g36lvv23ypjd8v7ovlst2n3yt

管理节点，解散集群
docker swarm leave --force
```

* 使用portainer/agent添加集群到 portainer上
* 使用`tcp://0.0.0.0:2375`方式添加到 portainer上

**对于portainer的组管理、用户管理、模板管理**

## 自定义的uts-docker-chrome

这个前提是在要操作的宿主机上build对于的容器镜像

1. 可以通过portainer添加docker实例
2. 通过命令行连接，可修改docker实例的host`/etc/hosts`和ulimit`ulimit -c 0`限制 

## 通过qadev的harbor来自动部署docker-chrome(方案可行)

[Harbor](https://docker.qadev.com/)

这里涉及到`docker login`、`docker push`、`docker build`等命令

```
优先build：tag名称规则，见下方
docker build -f chrome-dbg-zh-3.141 -t docker.qadev.com/uts/chrome:3.141.0 .

然后推送：
docker push docker.qadev.com/uts/chrome:3.141.0
```

```
1、登录
docker login http://xxxxx.com

2、登录私有hub创建项目
   例如项目叫：abc-dev

2、给镜像打tag
　　docker tag 2e25d8496557 xxxxx.com/abc-dev/arc:1334

　　2e25d8496557：IMAGE ID，可以用docker images 查看
　　xxxxx.com：私有hub域名
　　abc-dev：项目名称
　　arc：镜像名称
　　1334：镜像版本号

4、推送
　　docker push xxxxx.com/abc-dev/arc:1334　　
```


docker run --add-host=wap.qadev.com:10.1.1.1 --add-host=m.qadev.com:10.1.1.1 



## 删除不掉容器文件占用，其实是网络问题。

解决办法如下

1、docker stop 容器ID\容器名   先暂停

2、docker network disconnect --force bridge 容器ID\容器名   清除网络

3、docker rm -f 容器ID\容器名  再强制删除


@TODO /var/cache/fontconfig# ls | xargs -n 10 rm -f


## uts 代理机器配置

docker build -f browsermob -t docker.qadev.com/uts/browsermob:2.14 .

docker run -it -p 11011:8080 --name ust-proxy docker.qadev.com/uts/browsermob:2.14 

## 20201020 
批量清理和重置uts-docker

```
cd /qadev/odin/uts/
docker-compose -f compose-uts.yml stop
docker-compose -f compose-uts.yml rm 
docker-compose -f compose-uts.yml up -d
```

### 20210120 使用docker-slim精简images

docker.qadev.com/sqa-base/tomcat

/Users/apple/tools/docker-slim build --target docker.qadev.com/sqa-base/tomcat:8-jdk8 --tag docker.qadev.com/sqa-base/tomcat:8-jdk8-slim --http-probe=false

使用portainer+docker-socket+仓库模式部署服务