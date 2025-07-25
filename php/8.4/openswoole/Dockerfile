ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-cli-alpine
LABEL maintainer="Guney Can Gokoglu (@gcg)"

## System dependencies for PHP extensions
RUN set -ex && \
        apk --update add libstdc++ libpq curl && \
        apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev linux-headers brotli-dev \
        postgresql-dev openssl-dev pcre-dev pcre2-dev sqlite-dev libpq \
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

## Install OpenSwoole
RUN pecl install openswoole-25.2.0
RUN docker-php-ext-enable openswoole

## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


## Clean
# RUN apk del .build-deps
