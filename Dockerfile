FROM ubuntu:16.04
MAINTAINER Alexander Hauser <alexander.ha18@gmail.com>

RUN apt-get -qq update
RUN apt-get -y install apache2
RUN apt-get -y install php libapache2-mod-php

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN mkdir -p /var/lock/apache2 /var/run/apache2

EXPOSE 80

VOLUME /var/www/html

CMD /bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"
