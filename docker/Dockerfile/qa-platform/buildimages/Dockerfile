FROM docker.qadev.com/jayzhen/node13-alpine:v2

WORKDIR /data/daemon

RUN    git clone https://myuser:mypwd@git.qadev.com/searchqa/team/background/bg_platform/backendQC/qa_platform_code.git /data/daemon/ \
        && npm install \
        && pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
