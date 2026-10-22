ARG PHP_VERSION=8.5
FROM php:${PHP_VERSION}-cli-alpine
LABEL maintainer="Guney Can Gokoglu (@gcg)"

## System dependencies for PHP extensions
RUN set -ex && \
        apk --update add libstdc++ libpq curl tini && \
        apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev linux-headers brotli-dev \
        postgresql-dev openssl-dev pcre-dev pcre2-dev sqlite-dev \
        icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev \
        libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev \
        libxml2-dev \
        gmp-dev \
        oniguruma-dev

## Required PHP extensions
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install -j$(nproc) pdo_mysql pdo_pgsql pdo_sqlite opcache gd zip intl bcmath pcntl sockets curl mbstring

## APCu for storing Prometheus metrics and other in-pod memory caches
RUN pecl install apcu && \
    docker-php-ext-enable apcu && \
    echo "apc.enable_cli = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini

## IGBinary & Redis
RUN pecl install igbinary && \
    pecl install --configureoptions 'enable-redis-igbinary="yes"' redis && \
    docker-php-ext-enable igbinary redis

## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## Install Swoole
ARG SWOOLE_VERSION=v6.1.4
RUN docker-php-source extract && \
    mkdir /usr/src/php/ext/swoole && \
    curl -sfL https://github.com/swoole/swoole-src/archive/${SWOOLE_VERSION}.tar.gz -o swoole.tar.gz && \
    tar xfz swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole && \
    docker-php-ext-configure swoole && \
    docker-php-ext-install -j$(nproc) swoole && \
    rm -f swoole.tar.gz && \
    docker-php-source delete

## Clean PECL temporary files
RUN rm -rf /tmp/pear ~/.pearrc

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["php", "-a"]
