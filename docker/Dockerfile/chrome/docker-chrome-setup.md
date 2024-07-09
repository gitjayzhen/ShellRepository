# 使用docker版本的chrome来支持UTS的UI自动化


## 1. 需要一个linux服务器


1.`uname -r`命令得到linux内核版本需要 > 3.0

2.确认安装docker（docker ps/ systemctl status docker）这里了先省略没有安装的步骤，戳这里按官网安装步骤[dockerhub](https://docs.docker.com/install/linux/docker-ce/centos/)

3.安装后或已安装了，确认下是否开放了`2375`端口（netstat -anop | grep 2375）,如果确认是docker占用，到这里就结束了，否则看第四步
```
tcp6       0      0 :::2375                 :::*                    LISTEN      11692/dockerd        off (0.00/0/0)
```

4.需要开启docker服务的2375端口，来支持远程访问

```
1. 修改/etc/docker/daemon.json (如果没有这个daemon.json没有，创建就行)，添加内容

{
  "hosts":[
    "unix:///var/run/docker.sock",
    "tcp://0.0.0.0:2375"
  ]
}

如果已有文件内容，只需在内容底部，{}内添加host内容即可

2. 重启docker服务 `systemctl restart docker`

提示：这里可能会出现异常，问题排查，/usr/lib/systemd/system/docker.service文件里的ExecStart是否带了-H，导致当前的daeson.json中的-H无法使用,删除ExecStart中的-H 及其参数即可，有什么疑问@jayzhen
```

5.验证下docker服务是否正常，`docker ps`

## 2. 使用portainer工具来构建测试使用的uts-chrome客户端

1.http://uts.qadev-inc.com:19000/#/containers/new （admin/admin123）添加端点

* 通过docker的socket通信来建立管理连接

2.添加完端点后，从首页列表中点击对应刚刚添加的服务器，去添加容器(6不完成新建)

* 1.通过首页-> 端点列表->进入到所要操作的机器上

* 2.进入当前机器的容器列表页

* 3.已存在的容器列表，点击添加容器

* 4.新添加容器的配置页

```
name: 指的是后面运行的容器名称，最好是英文，且不可重复
镜像： 为uts-chrome容器的基础镜像，默认填：uts/chrome:3.141.0
注册表： 是uts-chrome镜像的仓库存储地方，默认选：docker-reg-qadev
端口映射： 是指容器内容服务的端口对接宿主机的端口，容器内部端口4444: selenium服务的端口，5900:docker桌面服务；需要将两个端口映射到宿主机上，供uts测试使用；端口不可重复
Enable access control ： 默认勾选就行，使用administrator方案
```

* 5.配置docker容器的选项

```shell
主要配置：
volumes、env、restart policy

volumes: /dev/shm:/dev/shm (必要配置）

env: SCREEN_WIDTH=1930、SCREEN_HEIGHT=1090 （可选配置）

restart policy: always (必选配置)
```

* 6.配置restart policy: always

## 3. 进入容器命令行模式，进行linux环境参数配置

```shell
1. 为了防止容器日志爆表，`进入容器命令行`设置下ulimit -c 0
2. 同方式，进入命令行模式，可以使用vim /etc/hosts来修改服务的hosts,以达到测试环境的转变
```

* 1.容器列表进入到容器的命令行界面 
* 2.连接进入 

* 3.命令行状态，同正常的linux命令行，不建议安装软件

* 4.断开链接直接点击 `disconnect`


## 4. 已有容器，后续添加只需复制即可

* 1.找到已存在的容器，点击进入详情页  

* 2.点击复制进入到编辑页 

* 3.修改不可重复的参数，即可提交，生成新的容器 


* 4.为了防止容器日志爆表，进入容器设置下ulimit -c 0


## 5. 如何查找uts使用的端口

服务上使用`dokcer ps`, ports栏中的端口就是我们需要关注的，映射对应4444的就是uts任务执行使用的端口

```
CONTAINER ID        IMAGE                                                     COMMAND                  CREATED             STATUS              PORTS                                             NAMES
98f1ceb75bd4        docker.qadev.com/shequ_qadev/uts-chrome:3.141.0   "/opt/bin/entry_poin…"   37 minutes ago      Up 37 minutes       0.0.0.0:14446->4444/tcp, 0.0.0.0:6902->5900/tcp   uts-chrome-14446
f986e14db3fc        docker.qadev.com/shequ_qadev/uts-chrome:3.141.0   "/opt/bin/entry_poin…"   38 minutes ago      Up 38 minutes       0.0.0.0:14445->4444/tcp, 0.0.0.0:6901->5900/tcp   uts-chrome-14445
8508ffefb713        docker.qadev.com/shequ_qadev/uts-chrome:3.141.0   "/opt/bin/entry_poin…"   About an hour ago   Up About an hour    0.0.0.0:14444->4444/tcp, 0.0.0.0:6900->5900/tcp   uts-chrome-14444
```

portainer平台上，容器列表就能看到对应的端口
