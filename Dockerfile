FROM ubuntu:16.04

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

LABEL vendor="Jonathan A. Schweder <jonathanschweder@gmail.com>"
LABEL version="1.0.0"
LABEL description="Basic image for PHP development and production ready with NGINX, PHP-FPM and Supervisord"

# update and upgrade
RUN apt-get update -y && apt-get upgrade -y

# install build dependencies
RUN apt-get install --no-install-recommends --no-install-suggests -y \
	    ca-certificates \
            nginx \
            supervisor \
            git \
            make \
            autoconf \
            build-essential \
            bison \
            libxml2-dev \
            libbz2-dev \
            libmcrypt-dev \
            libpq-dev \
            libcurl4-openssl-dev \
            pkg-config

# clear apt-get repositories lists
RUN rm -rf /var/lib/apt/lists/*

# remove unecessary and temporary files
RUN apt-get autoremove
RUN apt-get autoclean

# clone the php language repository
RUN git clone --depth 1 -b master git://github.com/php/php-src /usr/src/php

WORKDIR /usr/src/php

# generate make files
RUN ./buildconf

# configure php installation with common libs, (if you need php-cli please remove the "--disable-cli" line)
RUN ./configure \
    --disable-cli \
    --disable-cgi \
    --disable-short-tags \
    --enable-intl \
    --enable-fpm \
    --enable-bcmath \
    --enable-mbstring \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
    --with-zlib \
    --with-bz2 \
    --with-openssl \
    --with-mcrypt \
    --with-pdo-mysql \
    --with-pdo-pgsql

# run make in paralel with (number of processors + 1) threads
RUN make -j$(($(nproc)+1))

# install php
RUN make install

# config php
RUN cp ./php.ini-production /usr/local/php/php.ini

# delete php-src directory
RUN rm -rf /usr/src/php

# disable cgi path fixing to avoid script injection
RUN echo "cgi.fix_pathinfo=0" >> /usr/local/php/php.ini

# config nginx
WORKDIR /etc/nginx/sites-available
COPY ./nginx/sites-available/* ./

# onfig php-fpm
WORKDIR /usr/local/etc/
COPY ./php-fpm/php-fpm.conf ./
COPY ./php-fpm/php-fpm.d/*.conf ./php-fpm.d/

# config supervisor
WORKDIR /etc/supervisor
COPY ./supervisor/supervisord.conf ./
COPY ./supervisor/conf.d/*.conf ./conf.d/

# create example php file
WORKDIR /var/www/html/
RUN echo "<?php phpinfo();" > index.php

EXPOSE 80 443

CMD ["supervisord","-c","/etc/supervisor/supervisord.conf","--nodaemon"]
