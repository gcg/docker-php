#!/usr/bin/env sh
set -e

ROLE="${CONTAINER_ROLE:-${APP_ENV:-web}}"

echo "Starting container with role: ${ROLE}"

# Optional pre-run cache commands for production (opt-in via RUN_OPTIMIZATIONS=true)
if [ "${RUN_OPTIMIZATIONS:-false}" = "true" ]; then
    echo "Warming Laravel caches..."
    php /var/www/html/artisan config:cache || true
    php /var/www/html/artisan route:cache || true
    php /var/www/html/artisan view:cache || true
    php /var/www/html/artisan event:cache || true
fi

case "${ROLE}" in
    web|app)
        echo "Launching PHP-FPM and Nginx under Supervisord..."
        exec /usr/bin/supervisord -n -c /etc/supervisord.conf
        ;;
    worker|queue)
        echo "Launching queue worker..."
        exec php /var/www/html/artisan queue:work \
            --verbose \
            --tries="${QUEUE_TRIES:-3}" \
            --timeout="${QUEUE_TIMEOUT:-90}" \
            --sleep="${QUEUE_SLEEP:-3}"
        ;;
    scheduler)
        echo "Launching scheduler..."
        exec php /var/www/html/artisan schedule:work --verbose --no-interaction
        ;;
    *)
        echo "Executing custom command: $@"
        exec "$@"
        ;;
esac
