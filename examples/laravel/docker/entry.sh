#!/usr/bin/env sh

set -e
env=${APP_ENV:-prod}
version=${VERSION:-na}
branch=${BRANCH:-local}

if [ "$version" = "na" ]; then
    version=$branch
fi

php=/usr/local/bin/php
artisan=/var/www/html/artisan

echo "Running pre-run commands... ";
$php $artisan route:clear
$php $artisan config:clear
$php $artisan version:set $version


if [ "$env" = "worker" ]; then
    exec /usr/bin/supervisord -n -c /etc/worker.conf
elif [ "$env" = "scheduler" ]; then
    while [ true ]
    do
      /usr/local/bin/php /var/www/html/artisan schedule:run --verbose --no-interaction &
      sleep 60
    done
else
    exec /usr/bin/supervisord -n -c /etc/supervisord.conf
fi
