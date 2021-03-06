FROM php:fpm-alpine

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
RUN cd /tmp && \
        wget https://github.com/igbinary/igbinary/archive/3.1.2.zip && \
        unzip 3.1.2.zip && cd igbinary-3.1.2 && \
        phpize && ./configure && make && make install && \
        docker-php-ext-enable igbinary

# install memcached
RUN cd /tmp && \
        wget https://github.com/php-memcached-dev/php-memcached/archive/v3.1.5.zip && \
        unzip v3.1.5.zip && cd php-memcached-3.1.5 && \
        phpize && ./configure --enable-memcached-igbinary && make && make install && \
        docker-php-ext-enable memcached

# install phpredis
RUN cd /tmp && \
        wget https://github.com/phpredis/phpredis/archive/5.2.1.zip && \
        unzip 5.2.1.zip && cd phpredis-5.2.1 && \
        phpize && ./configure --enable-redis-igbinary && make && make install && \
        docker-php-ext-enable redis
