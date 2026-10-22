ARG PHP_VERSION=8.5
FROM php:${PHP_VERSION}-fpm-alpine
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
RUN docker-php-ext-install -j$(nproc) pdo_mysql pdo_pgsql opcache gd zip intl bcmath pcntl sockets curl mbstring

## APCu for storing Prometheus metrics and other in-pod memory caches
RUN pecl install apcu && docker-php-ext-enable apcu

## IGBinary & Redis
RUN pecl install igbinary && \
    pecl install --configureoptions 'enable-redis-igbinary="yes"' redis && \
    docker-php-ext-enable igbinary redis

## Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## Should we install nginx?
ARG INSTALL_NGINX=true
RUN if [ "${INSTALL_NGINX}" = "true" ]; then \
        apk --update add --no-cache nginx; \
    fi

## Should we install supervisord?
ARG INSTALL_SUPERVISOR=true
RUN if [ "${INSTALL_SUPERVISOR}" = "true" ]; then \
        apk --update add --no-cache supervisor; \
    fi

## Clean PECL temporary files
RUN rm -rf /tmp/pear ~/.pearrc

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["php-fpm", "-F"]
