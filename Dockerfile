FROM ubuntu:14.04

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

# update and upgrade
RUN apt-get update -y \
    && apt-get upgrade -y

# install build dependencies
RUN apt-get install \
    ca-certificates \
    wget \
    git \
    make \
    autoconf \
    build-essential \
    libxml2-dev \
    libbz2-dev \
    libmcrypt-dev \
    libpq-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libreadline-dev \
    libxslt-dev \
    pkg-config \
    --no-install-recommends \
    --no-install-suggests \
    -y

RUN mkdir /usr/src/bison

WORKDIR /usr/src/bison

# install libbison 2.7
RUN wget http://launchpadlibrarian.net/140087283/libbison-dev_2.7.1.dfsg-1_amd64.deb && \
    wget http://launchpadlibrarian.net/140087282/bison_2.7.1.dfsg-1_amd64.deb && \
    dpkg -i libbison-dev_2.7.1.dfsg-1_amd64.deb && \
    dpkg -i bison_2.7.1.dfsg-1_amd64.deb

# clone the php language repository
RUN git clone -b PHP-5.6 --depth 1 git://github.com/php/php-src /usr/src/php

WORKDIR /usr/src/php

# generate build files
RUN ./buildconf

# configure php installation with common libs
RUN ./configure \
    --disable-cgi \
    --disable-short-tags \
    --enable-bcmath \
    --enable-mbstring \
    --enable-pcntl \
    --enable-maintainer-zts \
    --enable-fpm \
    --with-xsl \
    --with-zlib \
    --with-bz2 \
    --with-openssl \
    --with-mcrypt \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-readline \
    --with-curl \
    --with-libzip

# run make in paralel with (number of processors + 1) threads
RUN make -j$(($(nproc)+1))

# install php
RUN make install

# config php
RUN cp ./php.ini-production /usr/local/php.ini

# disable cgi path fixing to avoid script injection
RUN echo "cgi.fix_pathinfo=0" >> /usr/local/php.ini \
    && echo "date.timezone = America/Sao_Paulo" >>  /usr/local/php.ini

# clear apt-get repositories lists
RUN rm -rf /var/lib/apt/lists/*

# remove unecessary and temporary files
RUN apt-get autoremove
RUN apt-get autoclean

WORKDIR /var/www

VOLUME /var/www

EXPOSE 80

CMD ["php", "-v"]
