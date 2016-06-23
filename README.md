![PHP](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/php/logo.png)

# Supported tags

 - latest

[![Build Status](https://travis-ci.org/jaschweder/docker-image-php.svg?branch=cli)](https://travis-ci.org/jaschweder/docker-image-php)
[![](https://imagelayers.io/badge/jaschweder/php:latest.svg)](https://imagelayers.io/?images=jaschweder/php:latest 'Get your own badge on imagelayers.io')

# What's inside ?

 - [PHP](https://github.com/php/php-src) with php-fpm compiled from branch master

# How to use this image

### With Command Line
```
<<<<<<< HEAD
docker run -d jaschweder/php:nginx
```
This will start a container instance with Nginx, PHP-FPM and Supervisord services running, the default website root is ```/var/www/html```.

### Create a Dockerfile in your PHP project

```
FROM jaschweder/php:nginx
COPY . /var/www/html
WORKDIR /var/www/html
CMD [ "supervisord", "-c", "/etc/supervisor/supervisord.conf", "--nodaemon" ]
```

=======
docker run -it jaschweder/php php -i
```
>>>>>>> 33e67b731a43254db305827145367dfc9d065a53
> Created and mantained by Jonathan A. Schweder <jonathanschweder@gmail.com>
