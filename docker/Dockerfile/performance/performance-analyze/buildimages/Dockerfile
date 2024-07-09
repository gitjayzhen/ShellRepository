FROM centos:7.2.1511

# Install packages 
RUN    yum install -y rsyslog wget redhat-lsb rsync git mysql mysql-devel\
        && wget http://docker.qadev.com/jayzhen/scripts/raw/master/hadoop/install/install.sh \
        && sh install.sh sunshine-js\
        && wget http://cloud.qadev-inc.com/downloads/hadoop-sunshine-js.tar.gz \
        && mkdir -p /usr/local/hadoop\
        && tar zxvf hadoop-sunshine-js.tar.gz  -C /usr/local/hadoop\
        && echo "web_qa01,ed80f761cb8185aa60b6785f7d656c79">~/ugi_config \
        && rm -f hadoop-sunshine-js.tar.gz \
        && wget http://d.qadev/download/hadoop/conf/SunshineJS-2.6.0.tar.gz  \
        && tar zxvf SunshineJS-2.6.0.tar.gz \
        && mkdir -p /usr/local/gohdfs/ \
        && mv SunshineJS-2.6.0/gohdfs/SunshineJS /usr/local/gohdfs/SunshineJS \
        && rm -rf SunshineJS-2.6.0 SunshineJS-2.6.0.tar.gz \
        && sed -i "s#/usr/lib/jvm/java#/usr/local/hadoop/sunshine/java#g" /etc/hadoop/conf/hadoop-env.sh \
        && mkdir -p /data/daemon \
        && git clone -b log_monitor https://git.qadev.com/jayzhen/report-docker.git  /data/daemon/ \
        && echo -e "* * * * * sh /data/daemon/start.sh > /dev/null 2>&1" >>crontab.tmp \
        && crontab crontab.tmp \ 
        && rm -f crontab.tmp 

# Add nodefile to the Path
WORKDIR /data/daemon/
ENV LANG=C.UTF-8
