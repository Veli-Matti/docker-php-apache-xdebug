FROM php:7.2-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql sockets
RUN pecl install xdebug-2.8.0
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini
