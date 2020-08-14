FROM php:7.2-apache
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y git mariadb-client unzip
RUN apt-get install -y libicu-dev
RUN apt-get install -y libzip-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libonig-dev
RUN apt-get install -y libc-client-dev libkrb5-dev

# Install nvm and node v12
SHELL ["/bin/bash", "--login", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN nvm install 12

# Apache modules
RUN a2enmod headers rewrite ssl

# TODO. Base php.ini
# COPY ./php.ini /usr/local/etc/php/

# PHP extensions
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap pdo_mysql sockets intl zip gd xml soap mbstring exif
RUN pecl install xdebug-2.8.0
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
