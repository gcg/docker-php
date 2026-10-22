#!/usr/bin/env sh
set -e

# If user provided a custom CLI command (e.g. "php artisan migrate" or "sh"), execute it directly
if [ $# -gt 0 ] && [ "$1" != "web" ] && [ "$1" != "app" ] && [ "$1" != "worker" ] && [ "$1" != "worker-dsc" ] && [ "$1" != "queue" ] && [ "$1" != "scheduler" ]; then
    exec "$@"
fi

# Determine container role: precedence is $1 -> $CONTAINER_ROLE -> $APP_ENV mapping -> default "web"
ROLE="${1:-${CONTAINER_ROLE}}"
if [ -z "${ROLE}" ]; then
    case "${APP_ENV}" in
        worker|worker-dsc|queue) ROLE="worker" ;;
        scheduler) ROLE="scheduler" ;;
        *) ROLE="web" ;;
    esac
fi

php=/usr/local/bin/php
artisan=/var/www/html/artisan

echo "Starting container with role: ${ROLE}"

# Pre-run version tagging if artisan version:set is registered
if [ -n "${VERSION}" ] && [ -f "${artisan}" ]; then
    $php $artisan version:set "${VERSION}" 2>/dev/null || true
fi

# Optional pre-run cache optimizations (opt-in via RUN_OPTIMIZATIONS=true)
if [ "${RUN_OPTIMIZATIONS:-false}" = "true" ] && [ -f "${artisan}" ]; then
    echo "Optimizing Laravel (config, routes, views, events)..."
    $php $artisan optimize || true
fi

case "${ROLE}" in
    web|app)
        echo "Launching PHP-FPM and Nginx under Supervisord..."
        exec /usr/bin/supervisord -n -c /etc/supervisord.conf
        ;;
    worker|worker-dsc|queue)
        # Check if Laravel Horizon is installed, otherwise fallback to standard queue:work
        if $php $artisan list | grep -q 'horizon'; then
            echo "Launching Laravel Horizon queue supervisor..."
            exec $php $artisan horizon
        else
            echo "Launching standard queue worker..."
            exec $php $artisan queue:work \
                --verbose \
                --tries="${QUEUE_TRIES:-3}" \
                --timeout="${QUEUE_TIMEOUT:-90}" \
                --sleep="${QUEUE_SLEEP:-3}"
        fi
        ;;
    scheduler)
        echo "Launching Alpine crond for Laravel scheduler..."
        echo "* * * * * /usr/local/bin/php /var/www/html/artisan schedule:run >> /dev/stdout 2>&1" >> /var/spool/cron/crontabs/root
        exec crond -l 2 -f
        ;;
    *)
        exec "$@"
        ;;
esac
