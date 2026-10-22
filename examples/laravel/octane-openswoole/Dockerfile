FROM guneycan/php:8.5-openswoole

LABEL maintainer="Guney Can Gokoglu (@gcg)"

WORKDIR /var/www/html

# Custom PHP settings for Laravel Octane
COPY docker/php.ini /usr/local/etc/php/conf.d/99-laravel.ini

# Copy entrypoint script
COPY docker/entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh

# Install composer dependencies first to leverage Docker layer caching
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

# Copy application source
COPY . ./

# Dump optimized autoloader and set directory permissions
RUN composer dump-autoload --optimize --no-dev && \
    mkdir -p storage/framework/sessions \
             storage/framework/views \
             storage/framework/cache \
             bootstrap/cache && \
    chown -R www-data:www-data storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

# Standard port for containerized platforms (Cloud Run, ECS, Kubernetes)
ENV PORT=8080
EXPOSE ${PORT}

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entry.sh"]
CMD ["web"]
