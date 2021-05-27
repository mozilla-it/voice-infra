FROM ubuntu:focal

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        libssl-dev \
        mysql-client \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz \
    && cd redis-stable \
    && make BUILD_TLS=yes \
    && cp src/redis-cli /usr/local/bin/ \
    && chmod +x /usr/local/bin/redis-cli \
    && cd .. \
    && rm -rf redis-stable redis-stable.tar.gz

RUN echo 'alias mysql="mysql --host $CV_MYSQLHOST --user $CV_MYSQLUSER --database voice -p$CV_MYSQL_PASS"' >> /root/.bashrc
