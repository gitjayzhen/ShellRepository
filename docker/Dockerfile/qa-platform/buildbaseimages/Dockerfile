FROM docker.qadev.com/jayzhen/node13-alpine:v1

# Install packages 
RUN    apk update \
        && apk upgrade \
        && apk add --update curl subversion libxml2 libxml2-dev libxslt libxslt-dev libc-dev gcc python-dev \
        && apk add --no-cache openssh 
