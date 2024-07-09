FROM python:3.7-alpine
# Install packages 
RUN    apk update \
        && apk upgrade \
        && apk add --update wget bash bc python3-dev libxslt-dev gcc make g++ git rsync openssh sshpass
WORKDIR /data/daemon

RUN    wget http://10.0.0.0:81/httprunner/v3.1.4/sg-runner-3.1.4.tar.gz \
        && pip install sg-runner-3.1.4.tar.gz -i https://pypi.tuna.tsinghua.edu.cn/simple \
        && rm -f sg-runner-3.1.4.tar.gz

