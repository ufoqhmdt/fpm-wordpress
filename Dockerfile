OM ubuntu:14.04
MAINTAINER Pavel Litvyak <pvlltvk@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y dist-upgrade

RUN echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update

RUN apt-get -y install php5 php5-gd php5-ldap \
    php5-sqlite php5-pgsql php-pear php5-mysql \
    php5-mcrypt php5-xmlrpc php5-fpm

RUN sed -i '/daemonize /c \
daemonize = no' /etc/php5/fpm/php-fpm.conf

RUN sed -i '/error_log /c \
error_log = /var/log/php5-fpm/php5.6-fpm.log' /etc/php5/fpm/php-fpm.conf

RUN sed -i '/^listen /c \
listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf

RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf

RUN mkdir -p /var/log/php5-fpm && \
    chown -R www-data:www-data /var/log/php5-fpm

RUN mkdir -p /var/www && \
    echo "<?php phpinfo(); ?>" > /var/www/index.php && \
    chown -R www-data:www-data /var/www

EXPOSE 9000
VOLUME /var/www
VOLUME /var/log/php5-fpm
ENTRYPOINT ["php5-fpm"]
