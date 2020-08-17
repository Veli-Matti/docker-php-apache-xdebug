FROM php:7.2-apache
ARG DEBIAN_FRONTEND=noninteractive
    RUN apt-get update && apt-get install -y \
        git  \
        mariadb-client  \
        unzip \
        poppler-utils \
        libicu-dev \
        libzip-dev \
        libpng-dev \
        libxml2-dev \
        libonig-dev \
        libc-client-dev \
        libkrb5-dev \
    && apt-get -y clean && apt-get -y autoremove --purge

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

# imagick (proto)
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions imagick

RUN pecl install xdebug-2.8.0
RUN docker-php-ext-enable xdebug

# Very basic php.ini definitions
RUN (echo 'xdebug.remote_enable=1'; \
    echo 'error_log="/tmp/php_error_log"'; \
    echo 'max_input_vars=3000') \
        >> /usr/local/etc/php/php.ini
# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Allow pdf conversations
RUN cat /etc/ImageMagick-6/policy.xml | grep -v -E "coder.*PDF" > policy.xml && \
        mv policy.xml /etc/ImageMagick-6/policy.xml
