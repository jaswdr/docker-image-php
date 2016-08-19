FROM jaschweder/php:5.6

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

# install extensions
COPY ./ext /usr/src/ext

# install sqlanywhere
WORKDIR /usr/src/ext/sqlanywhere
RUN echo $PWD \
    && phpize \
    && ./configure \
    && make -j$(($(nproc)+1)) \
    && make install \
    && echo 'extension=sqlanywhere.so' >> /usr/local/lib/php.ini

ARG SYBASE_KEY=''

RUN wget http://d5d4ifzqzkhwt.cloudfront.net/sqla16client/sqla16_client_linux_x86x64.tar.gz \
    && tar -xvf sqla16_client_linux_x86x64.tar.gz \
    && cd client1600 \
    && ./setup  \
    -silent \
    -nogui \
    -I_accept_the_license_agreement \
    -sqlany-dir /opt/sqlanywhere16 \
    -regkey $SYBASE_KEY

ENV LD_LIBRARY_PATH=/opt/sqlanywhere16/lib64
