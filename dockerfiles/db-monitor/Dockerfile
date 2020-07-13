FROM ubuntu:focal

MAINTAINER "Alberto del Barrio <alberto@mozilla.com>"


RUN apt-get update && \
    apt-get install -y mysql-client redis-tools stunnel4

RUN echo 'alias mysql="mysql --host $CV_MYSQLHOST --user $CV_MYSQLUSER --database voice -p$CV_MYSQL_PASS"' >> /root/.bashrc
