FROM php:7.1-apache

MAINTAINER Reivaldo Oliveira <reivaldo@gmail.com>

RUN apt-get update -y && apt-get install --no-install-recommends -y \
       libmcrypt-dev \
       autoconf g++ make openssl libssl-dev libcurl4-openssl-dev pkg-config libsasl2-dev libpcre3-dev

RUN rm -r /var/lib/apt/lists/*

RUN rm -rf /var/www/html &&\
       mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html/public &&\
       chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html &&\
       ln -sf /dev/stderr /var/log/apache2/error.log &&\
       ln -sf /dev/stdout /var/log/apache2/access.log

COPY ./config/apache2.conf /etc/apache2/apache2.conf
COPY ./config/php.ini /usr/local/etc/php/

RUN pecl install mongodb && echo "extension=mongodb.so" > /usr/local/etc/php/php.ini

RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-configure mcrypt && docker-php-ext-install mcrypt

RUN a2enmod rewrite

RUN service apache2 restart

EXPOSE 80

VOLUME ["/var/www/html"]

#docker build -t php7.1-apache2 .

