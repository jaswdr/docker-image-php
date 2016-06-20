![PHP](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/php/logo.png)

[![Build Status](https://travis-ci.org/jaschweder/docker-image-php.svg?branch=master)](https://travis-ci.org/jaschweder/docker-image-php)

# Supported tags

 - latest

[![](https://imagelayers.io/badge/jaschweder/php:latest.svg)](https://imagelayers.io/?images=jaschweder/php:latest 'Get your own badge on imagelayers.io')

# What is PHP?

PHP is a server-side scripting language designed for web development, but which can also be used as a general-purpose programming language. PHP can be added to straight HTML or it can be used with a variety of templating engines and web frameworks. PHP code is usually processed by an interpreter, which is either implemented as a native module on the web-server or as a common gateway interface (CGI) (see [wiki](https://en.wikipedia.org/wiki/PHP)).

# How to use this image

### With Command Line
```
docker run -d jaschweder/php
```
This will start a container instance with Nginx, PHP-FPM and Supervisord services running, the default website root is ```/var/www/html```.

### Create a Dockerfile in your PHP project

```
FROM jaschweder\php:latest
COPY . /var/www/html
WORKDIR /var/www/html
CMD [ "supervisord", "-c", "/etc/supervisor/supervisord.conf", "--nodaemon" ]
```

> Created and mantained by Jonathan A. Schweder <jonathanschweder@gmail.com>
