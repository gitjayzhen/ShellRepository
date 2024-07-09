FROM alpine:latest
RUN mkdir  /home/cppcheck && cd /home/cppcheck
COPY ./cppcheck-1.90.tar.gz ./
RUN apk update \
        && apk upgrade \
        && apk add --update make g++ pcre-dev bash sshpass openssh rsync\
        && tar -zxf cppcheck-1.90.tar.gz && rm -f cppcheck-1.90.tar.gz \
        && cd cppcheck-1.90 \
        && make install FILESDIR=/cfg HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG --static" -j `getconf _NPROCESSORS_ONLN` \
        && strip /usr/bin/cppcheck \
        && rm -rf /home/cppcheck