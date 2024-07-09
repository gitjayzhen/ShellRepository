# *** 机器上的docker配置 (测试组)

## 20191009 添加docker-selenium=3.141版本


### 20190926 整理

### 使用的docker配置及命令

* 有docker环境的服务器
    * `A` ：`/data/docker-compose`
    * `B`  ：`/data/qadev/docker/docker-compose`

*命令使用主要是docker-compose编排和原生docker命令*

> 每个服务器下都可以直接使用全局命令docker，但是docker-compose命令需要结合docker-compose.yml文件才能执行，所以需要cd到指定docker-compose.yml同级目下录，才能执行命令，上面已经列出了docker-compose.yml文件

* docker管理相关命令
    * docker help   ： 可以查看有哪些命令
    * docker ps     ： 列出当前服务器docker引擎里的所有运行状态下的容器
    * docker ps -a  :  列出当前服务器所有的容器，包括已停止、运行中的容器
    * docker start/stop/restart [容器名或容器id]: 操作容器的启停

* docker-compose结合docker-compose.yml文件的命令
    * docker-compose up -d [容器名] : 后台启动一个指定容器，如果该容器已存在且运行中，将会略过；如果不存在，直接创建并运行
    * docker-compose up -d  ：运行所有容器（不推荐使用，因为有且容器不用或弃用，没有删除，会有影响）

* 通过docker-compose.yml新建容器
    * 可以直接修改源文件，复制一个节点，注意字段缩进
    * 其中节点名和容器名可以保持一致，但是与其他节点及其容器名不能相同
    * 新建容器如果涉及端口映射，宿主机端口不能重复使用
    * 如下列内容：web-c-9和web-c-10 service的两个容器
   
```
web-c-9:   # 服务名
    container_name: web-c-9  # 容器名
    image: selenium/standalone-chrome-debug-zh:2.53.1  # 镜像
    restart: always     # 自动重启
    dns:                # dns解析
        - 8.8.8.8
    ports:              # 端口映射
        - "14452:4444"  # 前面一个是宿主机端口：后一个是容器内端口
        - "15908:5900"
    volumes:            # 容器与宿主机共享的文件
        - /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime
        - /dev/shm:/dev/shm
    environment:        # 设置的容器里的环境变量
        - LOGSPOUT=ignore
web-c-10:
    container_name: web-c-10
    image: selenium/standalone-chrome-debug-zh:2.53.1
    restart: always
    dns:
        - 8.8.8.8
    ports:
        - "14453:4444"
        - "15909:5900"
    volumes:
        - /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime
        - /dev/shm:/dev/shm
    environment:
        - LOGSPOUT=ignore
```

## 根据dockerfile构建镜像

`docker build -f golang -t my-golang:1.8 .` 

`docker build -f ./dockerfile/chrome-zh-2.53.1  -t selenium/standalone-chrome-debug-zh:2.53.1 .`


##  docker  容器命名规则

1. 使用：项目名+'-'+[c|x|t] + '-" + 序号
2. 如：百科测试环境使用 ： beike-ct-1
3. 正常的执行线上使用： baike-c-2或beike-x-3
>c: 标识当前docker正常的debug版本且包含vnc视图模式插件，能够通过vnc连接查看执行过程   
x: 标识正常的chrome版本，且没有vnc视图模式，无法通过vnc连接查看执行过程  
t: 标识当前用于测试环境使用,配置了host（与c和x混合使用，ct或xt）

## 20191022 优化容器日志配置

1. 在docker-compose中使用logging来限制日志大小

## 20191030 优化vnc连接的视图大小

1. 通过environment参数来设置`SCREEN_WIDTH=1930``SCREEN_HEIGHT=1090`
2. 计划使用docker内容定时任务来处理docker内存溢出的情况[范例](https://www.jianshu.com/p/351a2b2b416b)

### 如果发现docker的驱动占用内容过大，通过驱动名去查找容器

>所谓的驱动占用其实是docker内部Ubuntu系统在发生异常的时候会dump堆栈内容，产生一个core的文件，保存在执行命令的当前目录下（可以通过/proc/sys/kernel/ 目录下的文件来查看：'/proc/sys/kernel/core_pattern'生成core的文件目录及命名方式，及'kernel.core_uses_pid'为1标识添加core.pid作为文件名,0标识以core为文件名）,详细的看下方解析

linux chrome /opt/google/chrome/chrome core.13

**在根目录下**

```
查看core file size： ulimit -c

core file size：
unlimited：core文件的大小不受限制
0：程序出错时不会产生core文件
1024：代表1024k，core文件超出该大小就不能生成了

设置core文件大小： ulimit -c fileSize

注意：

尽量将这个文件大小设置得大一些，程序崩溃时生成Core文件大小即为程序运行时占用的内存大小。可能发生堆栈溢出的时候，占用更大的内存

0X01 设置core文件的名称和文件路径

默认生成路径：输入可执行文件运行命令的同一路径下
默认生成名字：默认命名为core。新的core文件会覆盖旧的core文件

a.设置pid作为文件扩展名

1：添加pid作为扩展名，生成的core文件名称为core.pid
0：不添加pid作为扩展名，生成的core文件名称为core
修改 /proc/sys/kernel/core_uses_pid 文件内容为: 1
修改文件命令： echo “1” > /proc/sys/kernel/core_uses_pid
或者
sysctl -w kernel.core_uses_pid=1 kernel.core_uses_pid = 1

b. 控制core文件保存位置和文件名格式

修改文件： echo “/corefile/core-%e-%p-%t” > /proc/sys/kernel/core_pattern
或者：
sysctl -w kernel.core_pattern=/corefile/core-%e-%p-%t kernel.core_pattern = /corefile/core-%e-%p-%t
可以将core文件统一生成到/corefile目录下，产生的文件名为core-命令名-pid-时间戳
以下是参数列表:

%p - insert pid into filename 添加pid(进程id)
%u - insert current uid into filename 添加当前uid(用户id)
%g - insert current gid into filename 添加当前gid(用户组id)
%s - insert signal that caused the coredump into the filename 添加导致产生core的信号
%t - insert UNIX time that the coredump occurred into filename 添加core文件生成时的unix时间
%h - insert hostname where the coredump happened into filename 添加主机名
%e - insert coredumping executable name into filename 添加导致产生core的命令名
```


通过这个驱动好去查询是那个容器：
```
docker ps --format "{{.Names}}" | xargs docker inspect | grep -B 120 d125eb6d7f9d357bbfe33686b6342a5e17428aa516bdeaf8920f75f6516ef5b0 | grep Name
```

`d125eb6d7f9d357bbfe33686b6342a5e17428aa516bdeaf8920f75f6516ef5b0`是驱动的id



## 20191114 重新构建 3.141.0 - chorme_version=73.0.3683.75   chrome_driver=2.46

```
docker build --build-arg CHROME_VERSION=73.0.3683.75 --build-arg CHROME_DRIVER_VERSION=2.46 -f ./common/dockerfile/chrome-dbg-zh-3.141-a -t uts/chrome-dbg:3.141.0-a .
```

备注：如果想要构建自定义版本的chrome和chromedriver 需要你的机器能够访问dl-ssl.google.com和dl.google.com,
为什么呢？是因为原来的docker上下游依赖中，上面的docker已经把chrome和chromedriver版本已经安装配置好了，如果你想自定义
，就必须自己下载这两个，然而这两个工具所在的网址（不是随便访问的，有两个方法：找梯子或使用本地安装的方式：找到两个版本使用 copy命令和本地安装命令安装），还有就是selenium支持的chromedriver版本比较开阔，不会限制在某一个版本，但是过高会导致有且命令找不到；

## 20191216 完成基于docker的jenkins升级（2.138.3 -> 2.208）

## 20191223 微信搜索添加机器

# selenium集群搭建

为了支持二次验证搭建集群


docker build --ulimit core=0:0 -f uts-node-chrome-3.141 -t docker.qadev.com/shequ_qadev/uts-node-chrome:3.141.0 .

docker build -f uts-node-firefox-3.141 -t docker.qadev.com/shequ_qadev/uts-node-firefox:3.141.0 .

docker build  -f uts-hub-3.141 -t docker.qadev.com/shequ_qadev/uts-hub:3.141.0 .


docker build  -f uts-node-chrome-3.141 -t docker.qadev.com/uts/node-chrome:3.141.0 .

docker build  -f uts-hub-3.141 -t docker.qadev.com/uts/hub:3.141.0 .

### 20200314 

1. 先使用dockerfile中设置ulimit的方式，观察是否有core文件生成
2. 集群可进行使用