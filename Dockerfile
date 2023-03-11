ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm-alpine

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
ARG IGBINARY_VERSION=3.2.14
RUN cd /tmp && \
        wget https://github.com/igbinary/igbinary/archive/${IGBINARY_VERSION}.zip && \
        unzip ${IGBINARY_VERSION}.zip && cd igbinary-${IGBINARY_VERSION} && \
        phpize && ./configure && make && make install && \
        docker-php-ext-enable igbinary

# install memcached
ARG MEMCACHED_VERSION=3.2.0
RUN cd /tmp && \
        wget https://github.com/php-memcached-dev/php-memcached/archive/v${MEMCACHED_VERSION}.zip && \
        unzip v${MEMCACHED_VERSION}.zip && cd php-memcached-${MEMCACHED_VERSION} && \
        phpize && ./configure --enable-memcached-igbinary && make && make install && \
        docker-php-ext-enable memcached

# install phpredis
ARG REDIS_VERSION=5.3.7
RUN cd /tmp && \
        wget https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.zip && \
        unzip ${REDIS_VERSION}.zip && cd phpredis-${REDIS_VERSION} && \
        phpize && ./configure --enable-redis-igbinary && make && make install && \
        docker-php-ext-enable redis
