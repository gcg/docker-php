# set the PHP version, you can pick from 8.1 or 8.2
FROM guneycan/php:8.2

# clean up and create www
RUN mkdir -p /var/www && \
        rm -rf /tmp/*

# set workdir
WORKDIR /var/www/html

# copy all the files and run composer install.
COPY . ./
RUN composer install --no-dev --no-scripts
RUN chown -R www-data:www-data ./bootstrap && \
    chown -R www-data:www-data ./storage


# copy service configs and files
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY docker/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/php-upload.ini /usr/local/etc/php/conf.d/uploads.ini
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entry.sh /usr/bin/entry.sh

# default port to expose. if you update this, please update the nginx.conf as well.
ARG PORT=8080

EXPOSE ${PORT}

ENTRYPOINT ["/usr/bin/entry.sh"]
