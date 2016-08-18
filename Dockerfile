FROM jaschweder/php:5.6-tools

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

# update and upgrade
RUN apt-get update -y \
    && apt-get upgrade -y

# install build dependencies
RUN apt-get install \
    nginx \
    supervisor \
    --no-install-recommends \
    --no-install-suggests \
    -y

# clear apt-get repositories lists
RUN rm -rf /var/lib/apt/lists/*

# Nginx

RUN ln -sf /var/log/nginx/access.log /dev/stdout \
    && ln -sf /var/log/nginx/error.log /dev/stderr

COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./config/nginx/default /etc/nginx/sites-available/default

COPY ./index.php /var/www

# PHP-FPM

COPY ./config/php-fpm/php-fpm.conf /usr/local/etc/php-fpm.conf

# Supervisor

# remove unecessary and temporary files
RUN apt-get autoremove
RUN apt-get autoclean

WORKDIR /var/www

VOLUME /var/www

EXPOSE 80

CMD ["php", "-v"]
