FROM php:8.1-fpm-alpine

LABEL maintainer="Guney Can Gokoglu (@gcg)"

RUN apk --update add wget \
        curl \
        git \
        grep \
        nginx \
        build-base \
        libmemcached-dev \
        libmcrypt-dev \
        libxml2-dev \
        zlib-dev \
        autoconf \
        cyrus-sasl-dev \
        libgsasl-dev \
        supervisor \
        re2c \
        openssl \
        dcron \
        libpng-dev \
        libzip-dev \
        gmp-dev \
        icu-dev \
        mysql-client

RUN docker-php-ext-install mysqli pdo pdo_mysql xml opcache soap gd zip intl bcmath pcntl

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install igbinary
RUN cd /tmp && \
        wget https://github.com/igbinary/igbinary/archive/3.2.7.zip && \
        unzip 3.2.7.zip && cd igbinary-3.2.7 && \
        phpize && ./configure && make && make install && \
        docker-php-ext-enable igbinary

# install memcached
RUN cd /tmp && \
        wget https://github.com/php-memcached-dev/php-memcached/archive/v3.2.0.zip && \
        unzip v3.2.0.zip && cd php-memcached-3.2.0 && \
        phpize && ./configure --enable-memcached-igbinary && make && make install && \
        docker-php-ext-enable memcached

# install phpredis
RUN cd /tmp && \
        wget https://github.com/phpredis/phpredis/archive/5.3.7.zip && \
        unzip 5.3.7.zip && cd phpredis-5.3.7 && \
        phpize && ./configure --enable-redis-igbinary && make && make install && \
        docker-php-ext-enable redis
