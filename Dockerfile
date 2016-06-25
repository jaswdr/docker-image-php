FROM ubuntu

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

# update and upgrade
RUN apt-get update -y && apt-get upgrade -y

# install build dependencies
RUN apt-get install \
	    ca-certificates \
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
            pkg-config \
            --no-install-recommends --no-install-suggests -y

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

# configure php installation with common libs
RUN ./configure \
    --disable-cgi \
    --disable-short-tags \
    --enable-bcmath \
    --enable-mbstring \
    --with-zlib \
    --with-bz2 \
    --with-openssl \
    --with-mcrypt \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --enable-maintainer-zts

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

CMD ["php"]
