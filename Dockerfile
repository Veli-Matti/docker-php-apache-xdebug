FROM php:7.2-apache
RUN apt-get -y update && apt-get install -y libicu-dev
RUN docker-php-ext-install pdo_mysql sockets intl
RUN pecl install xdebug-2.8.0
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini
