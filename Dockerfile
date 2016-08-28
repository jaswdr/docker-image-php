FROM ubuntu:latest

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

RUN apt-get update -y \
    && apt-get upgrade -y

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
    libzip-dev \
    pkg-config \
    --no-install-recommends \
    --no-install-suggests \
    -y

RUN mkdir /usr/src/bison

WORKDIR /usr/src/bison

RUN wget http://launchpadlibrarian.net/140087283/libbison-dev_2.7.1.dfsg-1_amd64.deb && \
    wget http://launchpadlibrarian.net/140087282/bison_2.7.1.dfsg-1_amd64.deb && \
    dpkg -i libbison-dev_2.7.1.dfsg-1_amd64.deb && \
    dpkg -i bison_2.7.1.dfsg-1_amd64.deb

RUN git clone -b PHP-5.6 --depth 1 git://github.com/php/php-src /usr/src/php

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
    --with-zlib \
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

RUN make -j$(($(nproc)+1)) \
    && make install \
    && cp ./php.ini-production /usr/local/php.ini \
    && echo "cgi.fix_pathinfo=0" >> /usr/local/php.ini \
    && echo "date.timezone = America/Sao_Paulo" >>  /usr/local/php.ini \
    && rm -rf /var/lib/apt/lists/* /usr/src/* \
    && apt-get autoremove \
    && apt-get autoclean

WORKDIR /var/www

VOLUME /var/www

EXPOSE 80 443

CMD ["php", "-v"]
