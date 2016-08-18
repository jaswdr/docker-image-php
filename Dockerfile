FROM jaschweder/php:5.6-tools

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

############################################################################
#                               Dependencies                               #
############################################################################

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install \
    nginx \
    supervisor \
    --no-install-recommends \
    --no-install-suggests \
    -y

############################################################################
#                                   Nginx                                  #
############################################################################

RUN ln -sf /var/log/nginx/error.log /dev/stderr
COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./config/nginx/default /etc/nginx/sites-available/default

COPY ./index.php /var/www

############################################################################
#                               PHP-FPM                                    #
############################################################################

RUN ln -sf /var/log/php-fpm.log /dev/stderr
COPY ./config/php-fpm/php-fpm.conf /usr/local/etc/php-fpm.conf

############################################################################
#                             SUPERVISORD                                  #
############################################################################

COPY ./config/supervisor/supervisord.conf /etc/supervisor/conf.d

############################################################################
#                     CLEAN BUILD DEPENDENCIES PACKAGES                    #
############################################################################

RUN rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove \
    && apt-get autoclean

############################################################################
#                               GENERAL                                    #
############################################################################

WORKDIR /var/www

VOLUME /var/www

EXPOSE 80 443

CMD ["supervisord"]
