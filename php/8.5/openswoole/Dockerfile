ARG PHP_VERSION=8.5
FROM php:${PHP_VERSION}-cli-alpine
LABEL maintainer="Guney Can Gokoglu (@gcg)"

## System dependencies for PHP extensions
RUN set -ex && \
        apk --update add libstdc++ libpq curl tini && \
        apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev linux-headers brotli-dev \
        postgresql-dev openssl-dev pcre-dev pcre2-dev sqlite-dev libpq \
        icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev \
        libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev \
        libxml2-dev \
        gmp-dev \
        oniguruma-dev

## Required PHP extensions
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install -j$(nproc) pdo_mysql pdo_pgsql opcache gd zip intl bcmath pcntl sockets curl mbstring

## APCu for storing Prometheus metrics and other in-pod memory caches
RUN pecl install apcu && docker-php-ext-enable apcu

## IGBinary & Redis
RUN pecl install igbinary && \
    pecl install --configureoptions 'enable-redis-igbinary="yes"' redis && \
    docker-php-ext-enable igbinary redis

## Install OpenSwoole
RUN pecl install openswoole-26.2.0 && docker-php-ext-enable openswoole

## Clean PECL temporary files
RUN rm -rf /tmp/pear ~/.pearrc

## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["php", "-a"]
