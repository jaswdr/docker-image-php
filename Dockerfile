FROM ubuntu:16.04

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

RUN apt-get update -y \
    && apt-get upgrade -y

RUN apt-get install \
    ca-certificates \
    wget \
    git \
    mercurial \
    zip \
    make \
    autoconf \
    build-essential \
    bison \
    unzip \
    ssh \
    libxml2-dev \
    libbz2-dev \
    libmcrypt-dev \
    libpq-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libreadline-dev \
    libxslt-dev \
    libzip-dev \
    libpng12-dev \
    pkg-config \
    iputils-ping \
    --no-install-recommends \
    --no-install-suggests \
    -y

RUN git clone -b PHP-7.0 --depth 1 git://github.com/php/php-src /usr/src/php

WORKDIR /usr/src/php

RUN ./buildconf

RUN ./configure \
    --disable-cgi \
    --disable-short-tags \
    --enable-bcmath \
    --enable-mbstring \
    --enable-pcntl \
    --enable-maintainer-zts \
    --enable-fpm \
    --enable-soap \
    --enable-libxml \
    --enable-zip \
    --with-zlib \
    --with-xsl \
    --with-zlib \
    --with-bz2 \
    --with-openssl \
    --with-mcrypt \
    --with-mysqli \
    --with-pdo-mysql \
    --with-pgsql \
    --with-pdo-pgsql \
    --with-readline \
    --with-curl \
    --with-libzip \
    --with-gd

RUN make -j$(($(nproc)+1)) \
    && make install

RUN cp ./php.ini-production /usr/local/lib/php.ini \
    && echo "cgi.fix_pathinfo=0" >> /usr/local/lib/php.ini

RUN pecl install redis \
    && echo "extension=redis.so" >> /usr/local/lib/php.ini

RUN rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove \
    && apt-get autoclean

WORKDIR /var/www

VOLUME /var/www

EXPOSE 80 443
