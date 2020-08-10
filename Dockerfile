FROM php:7.2-apache
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --assume-yes \
        git \
        libicu-dev \
        libzip-dev \
        libpng-dev \
        libxml2-dev \
        libonig-dev
RUN a2enmod headers
RUN docker-php-ext-install pdo_mysql sockets intl zip gd xml soap mbstring exif
RUN pecl install xdebug-2.8.0
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini
