FROM jaschweder/php:5.6-server

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

############################################################################
#                                   Nginx                                  #
############################################################################

COPY ./nginx-vh-default /etc/nginx/sites-available/default

############################################################################
#                               GENERAL                                    #
############################################################################

WORKDIR /var/www

VOLUME /var/www

EXPOSE 80 443

CMD ["supervisord"]
