FROM node:13-alpine

# Install packages 
RUN    apk update \
        && apk upgrade \
        && apk add --update git nodejs nodejs-npm python py-pip sshpass bash bc pkgconfig pixman pixman-dev cairo cairo-dev pango pango-dev jpeg jpeg-dev giflib giflib-dev libpng libpng-dev make g++ tzdata font-adobe-100dpi ttf-dejavu fontconfig \
        && apk add --no-cache openssh \
        && rm -rf /var/cache/apk/* \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \ 
        && echo "Asia/Shanghai" > /etc/timezone \
        && npm config set unsafe-perm true \
        && npm install -g pm2 \
        && pip install requests 

COPY simsun.ttc /usr/share/fonts/win/
ENV NPM_CONFIG_LOGLEVEL info

RUN    chmod 777 /usr/share/fonts/win/simsun.ttc \
        && fc-cache -f \
        && fc-list

