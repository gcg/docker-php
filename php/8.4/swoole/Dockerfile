ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-cli-alpine
LABEL maintainer="Guney Can Gokoglu (@gcg)"

## System dependencies for PHP extensions
RUN set -ex && \
        apk --update add libstdc++ libpq curl && \
        apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev linux-headers brotli-dev \
        postgresql-dev openssl-dev pcre-dev pcre2-dev sqlite-dev \
        icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev \
        libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev \
        libxml2-dev \
        gmp-dev \
        icu-dev \
        oniguruma-dev

## Required PHP extensions
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install pdo_mysql pdo_pgsql opcache gd zip intl bcmath pcntl sockets curl mbstring

## APCu for storing Prometheus metrics and other in-pod memory caches
RUN pecl install apcu
RUN docker-php-ext-enable apcu

## IGBinary & Redis
RUN pecl install igbinary
RUN pecl install --configureoptions 'enable-redis-igbinary="yes"' redis
RUN docker-php-ext-enable igbinary && docker-php-ext-enable redis

## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## Install Swoole
ARG SWOOLE_VERSION=v6.0.0
RUN docker-php-source extract && \
        mkdir /usr/src/php/ext/swoole && \
        curl -sfL https://github.com/swoole/swoole-src/archive/${SWOOLE_VERSION}.tar.gz -o swoole.tar.gz && \
        tar xfz swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole && \
        docker-php-ext-configure swoole \
        --enable-mysqlnd       \
        --enable-swoole-pgsql  \
        --enable-swoole-sqlite \
        --enable-brotli        \
        --enable-openssl       \
        --enable-sockets --enable-swoole-curl && \
    docker-php-ext-install -j$(nproc) swoole && \
    rm -f swoole.tar.gz && \
    docker-php-source delete

## Clean
# RUN apk del .build-deps
