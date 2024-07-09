FROM alpine:3.8

# Install packages 
RUN    apk update \
        && apk upgrade \
        && apk add --update git nodejs nodejs-npm python sshpass openjdk8-jre bash tar unzip wget\
        && apk add --no-cache openssh\
        && rm -rf /var/cache/apk/*
# Install jmeter
RUN   mkdir /jmeter \
        && cd /jmeter/ \
        && wget http://10.1.1.1/jmeter-tgz/apache-jmeter-4.0.tgz \
        && tar -xzf apache-jmeter-4.0.tgz \
        && rm apache-jmeter-4.0.tgz \
        && mkdir /jmeter-plugins \
        && cd /jmeter-plugins/ \
        && wget http://10.1.1.1/jmeter-tgz/JMeterPlugins-ExtrasLibs-1.4.0.zip \
        && unzip -o JMeterPlugins-ExtrasLibs-1.4.0.zip -d /jmeter/apache-jmeter-4.0/ \
        && wget http://10.1.1.1/jmeter-tgz/jpgc-perfmon-2.0.zip \
        && unzip -o jpgc-perfmon-2.0.zip -d /jmeter/apache-jmeter-4.0
# Set Jmeter Home
ENV JMETER_HOME /jmeter/apache-jmeter-4.0/
# Add Jmeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH


# Add nodefile to the Path
ADD start.sh /data/daemon/
WORKDIR /data/daemon
ENV NPM_CONFIG_LOGLEVEL info
