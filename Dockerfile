FROM php:7.2-apache
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --assume-yes git mariadb-client
RUN apt-get install --assume-yes libicu-dev
RUN apt-get install --assume-yes libzip-dev
RUN apt-get install --assume-yes libpng-dev
RUN apt-get install --assume-yes libxml2-dev
RUN apt-get install --assume-yes libonig-dev

# Install nvm and node v12
SHELL ["/bin/bash", "--login", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN nvm install 12

# COPY ./php.ini /usr/local/etc/php/
RUN a2enmod headers rewrite ssl
RUN docker-php-ext-install pdo_mysql sockets intl zip gd xml soap mbstring exif
RUN pecl install xdebug-2.8.0
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini
