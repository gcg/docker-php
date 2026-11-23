ARG PHP_VERSION=8.6.0
FROM php:${PHP_VERSION}-cli-alpine
LABEL maintainer="Guney Can Gokoglu (@gcg)"

ARG OPENSWOOLE_VERSION=26.11.1

## Build all extensions in one layer so the toolchain and -dev packages never ship;
## scanelf keeps only the shared libs the compiled extensions actually link against.
## Official php:8.6 images dropped pecl in favor of PIE; mount the PIE binary at build time.
RUN --mount=from=ghcr.io/php/pie:bin,source=/pie,target=/usr/local/bin/pie \
    set -ex && \
    apk add --no-cache curl tini && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS git unzip libtool curl-dev linux-headers brotli-dev \
        postgresql-dev openssl-dev pcre-dev pcre2-dev sqlite-dev \
        icu-dev zlib-dev libzip-dev \
        libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev \
        libxml2-dev gmp-dev oniguruma-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) pdo_mysql pdo_pgsql gd zip intl bcmath pcntl sockets && \
    # TODO: switch apcu, igbinary, phpredis back to stable tags once released with PHP 8.6 support
    pie install -n --skip-enable-extension -j$(nproc) apcu/apcu:dev-master && \
    pie install -n --skip-enable-extension -j$(nproc) igbinary/igbinary:dev-master && \
    pie install -n --skip-enable-extension -j$(nproc) phpredis/phpredis:dev-develop --enable-redis-igbinary && \
    pie install -n --skip-enable-extension -j$(nproc) openswoole/ext-openswoole:${OPENSWOOLE_VERSION} \
        --enable-openssl --enable-http2 --enable-sockets --enable-hook-curl && \
    docker-php-ext-enable apcu igbinary redis && \
    docker-php-ext-enable --ini-name zz-docker-php-ext-openswoole.ini openswoole && \
    echo "apc.enable_cli = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    runDeps="$(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
        | tr ',' '\n' | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }')" && \
    apk add --no-cache $runDeps && \
    apk del --no-network .build-deps && \
    rm -rf /tmp/pie* ~/.pie

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["php", "-a"]
