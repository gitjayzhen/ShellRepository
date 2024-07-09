FROM mysql:5.7
COPY jmxs.sql /docker-entrypoint-initdb.d/
RUN chmod a+x /docker-entrypoint-initdb.d/jmxs.sql