FROM docker.qadev.com/jayzhen/node13-alpine:v1

# Install packages 
RUN       echo "0      1       *       *       *       sh /data/daemon/performance_report/clear.sh >> /search/clearlog &" >> /var/spool/cron/crontabs/root \
        && echo "*	*	*	*	*	sh /data/daemon/performance_report/shell_sql.sh > /search/log &" >> /var/spool/cron/crontabs/root

# Add nodefile to the Path
#WORKDIR /data/daemon
ENV NPM_CONFIG_LOGLEVEL info

RUN    git clone -b performance_report https://git.qadev.com/jayzhen/report-docker.git /data/daemon/ \
        && cd /data/daemon/performance_report \
        && npm install 

WORKDIR /data/daemon/performance_report


