FROM jaschweder/php:fpm

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

# config nginx
WORKDIR /etc/nginx/sites-available
COPY ./nginx/sites-available/* ./

# config php-fpm
WORKDIR /usr/local/etc/
COPY ./php-fpm/php-fpm.conf ./
COPY ./php-fpm/php-fpm.d/*.conf ./php-fpm.d/

# config supervisor
WORKDIR /etc/supervisor
COPY ./supervisor/supervisord.conf ./
COPY ./supervisor/conf.d/*.conf ./conf.d/

# create example php file
WORKDIR /var/www/html/

# enable volume
VOLUME /var/www/html

EXPOSE 80 443

ENTRYPOINT ["supervisord","-c","/etc/supervisor/supervisord.conf","--nodaemon"]
