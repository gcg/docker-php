FROM php:8-fpm-alpine

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
        libzip-dev

RUN docker-php-ext-install mysqli pdo pdo_mysql tokenizer xml opcache soap gd zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# install igbinary
ARG igbinary=3.2.1
RUN cd /tmp && \
        wget https://github.com/igbinary/igbinary/archive/$igbinary.zip && \
        unzip $igbinary.zip && cd igbinary-$igbinary && \
        phpize && ./configure && make && make install && \
        docker-php-ext-enable igbinary

# install memcached
ARG memcached=3.1.5
RUN cd /tmp && \
        wget https://github.com/php-memcached-dev/php-memcached/archive/v$memcached.zip && \
        unzip v$memcached.zip && cd php-memcached-$memcached && \
        phpize && ./configure --enable-memcached-igbinary && make && make install && \
        docker-php-ext-enable memcached

# install phpredis
ARG phpredis=5.3.2
RUN cd /tmp && \
        wget https://github.com/phpredis/phpredis/archive/$phpredis.zip && \
        unzip $phpredis.zip && cd phpredis-$phpredis && \
        phpize && ./configure --enable-redis-igbinary && make && make install && \
        docker-php-ext-enable redis
