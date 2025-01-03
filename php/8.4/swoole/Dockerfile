ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-cli-alpine
LABEL maintainer="Guney Can Gokoglu (@gcg)"

## System dependencies for PHP extensions
RUN set -ex && \
        apk --update add libstdc++ libpq curl && \
        apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev linux-headers brotli-dev \
        postgresql-dev openssl-dev pcre-dev pcre2-dev sqlite-dev zlib-dev \
        libxml2-dev \
        libpng-dev \
        libzip-dev \
        oniguruma-dev

## Required PHP extensions
RUN docker-php-ext-install pdo_mysql opcache gd zip intl bcmath pcntl sockets curl mbstring

## IGBinary & Redis
RUN pecl install igbinary
RUN pecl install --configureoptions 'enable-redis-igbinary="yes"' redis
RUN docker-php-ext-enable igbinary && docker-php-ext-enable redis

## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## Install Swoole
RUN pecl install -D 'enable-openssl="no" enable-mysqlnd="yes" enable-swoole-sqlite="yes" enable-brotli="yes" enable-openssl="yes" enable-sockets="yes" enable-swoole-curl="yes"' swoole
RUN docker-php-ext-enable swoole
