ARG PHP_VERSION=8.5.12
FROM php:${PHP_VERSION}-fpm-alpine
LABEL maintainer="Guney Can Gokoglu (@gcg)"

## Build all extensions in one layer so the toolchain and -dev packages never ship;
## scanelf keeps only the shared libs the compiled extensions actually link against.
RUN set -ex && \
    apk add --no-cache curl tini && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev linux-headers brotli-dev \
        postgresql-dev openssl-dev pcre-dev pcre2-dev sqlite-dev \
        icu-dev zlib-dev libzip-dev \
        libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev \
        libxml2-dev gmp-dev oniguruma-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) pdo_mysql pdo_pgsql gd zip intl bcmath pcntl sockets && \
    pecl install apcu igbinary && \
    pecl install --configureoptions 'enable-redis-igbinary="yes"' redis && \
    docker-php-ext-enable apcu igbinary redis && \
    echo "apc.enable_cli = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    runDeps="$(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
        | tr ',' '\n' | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }')" && \
    apk add --no-cache $runDeps && \
    apk del --no-network .build-deps && \
    rm -rf /tmp/pear ~/.pearrc

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

## Should we install nginx?
ARG INSTALL_NGINX=true
RUN if [ "${INSTALL_NGINX}" = "true" ]; then \
        apk add --no-cache nginx; \
    fi

## Should we install supervisord?
ARG INSTALL_SUPERVISOR=true
RUN if [ "${INSTALL_SUPERVISOR}" = "true" ]; then \
        apk add --no-cache supervisor; \
    fi

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["php-fpm", "-F"]
