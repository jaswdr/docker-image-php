FROM jaschweder/php

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

WORKDIR /usr/src

RUN apt-get update -y \
    && apt-get install libssl1.0.0 libgss3 g++-5 -y  \
    && wget http://www.unixodbc.org/unixODBC-2.3.1.tar.gz \
    && tar -xvzf unixODBC-2.3.1.tar.gz \
    && cd unixODBC-2.3.1 \
    && export CPPFLAGS="-DSIZEOF_LONG_INT=8" \
    && ./configure --prefix=/usr --libdir=/usr/lib64 --sysconfdir=/etc --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE \
    && make -j$($(nproc)+1) \
    && make install \
    && wget "https://meetsstorenew.blob.core.windows.net/contianerhd/Ubuntu%2013.0%20Tar/msodbcsql-13.0.0.0.tar.gz?st=2016-10-18T17%3A29%3A00Z&se=2022-10-19T17%3A29%3A00Z&sp=rl&sv=2015-04-05&sr=b&sig=cDwPfrouVeIQf0vi%2BnKt%2BzX8Z8caIYvRCmicDL5oknY%3D" -O msodbcsql-13.0.0.0.tar.gz -P msodbcubuntu \
    && tar -xvzf msodbcsql-13.0.0.0.tar.gz \
    && cd msodbcsql-13.0.0.0 \
    && ldd lib64/libmsodbcsql-13.0.so.0.0 \
    && echo "/usr/lib64" >> /etc/ld.so.conf \
    && ldconfig \
    && bash ./install.sh install --force --accept-license

WORKDIR /usr/src

RUN apt-get install unzip -y  \
    && wget https://github.com/Microsoft/msphpsql/releases/download/v4.0.5-Linux/Ubuntu16.zip \
    && unzip Ubuntu16.zip \
    && echo "extension=/usr/src/Ubuntu16/php_pdo_sqlsrv_7_ts.so" >> /usr/local/lib/php.ini \
    && echo "extension=/usr/src/Ubuntu16/php_sqlsrv_7_ts.so" >> /usr/local/lib/php.ini

RUN apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

WORKDIR /var/www
