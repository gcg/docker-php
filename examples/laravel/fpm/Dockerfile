FROM guneycan/php:8.5-fpm

LABEL maintainer="Guney Can Gokoglu (@gcg)"

WORKDIR /var/www/html

# Copy configuration files
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY docker/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/99-laravel.ini
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh

# Install composer dependencies first to leverage Docker layer caching
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

# Copy application code
COPY . ./

# Dump autoloader, create directories, and configure permissions
RUN composer dump-autoload --optimize --no-dev && \
    mkdir -p storage/framework/sessions \
             storage/framework/views \
             storage/framework/cache \
             bootstrap/cache \
             /var/log/nginx \
             /var/lib/nginx/tmp && \
    chown -R www-data:www-data storage bootstrap/cache /var/log/nginx /var/lib/nginx && \
    chmod -R 775 storage bootstrap/cache

# Standard web port
ENV PORT=8080
EXPOSE ${PORT}

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entry.sh"]
CMD ["web"]
