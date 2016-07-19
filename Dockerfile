FROM ubuntu:latest

MAINTAINER Jonathan A. Schweder "jonathanschweder@gmail.com"

# update and upgrade
RUN apt-get update -y \
    && apt-get upgrade -y

# install build dependencies
RUN apt-get install \
    php7.0 \
    php7.0-fpm \
    --no-install-recommends \
    --no-install-suggests -y

# clear apt-get repositories lists
RUN rm -rf /var/lib/apt/lists/*

# remove unecessary and temporary files
RUN apt-get autoremove
RUN apt-get autoclean

CMD ["php", "-v"]
