#!/usr/bin/env sh
set -e

ROLE="${CONTAINER_ROLE:-${APP_ENV:-web}}"
PORT="${PORT:-8080}"
OCTANE_WORKERS="${OCTANE_WORKERS:-auto}"
OCTANE_TASK_WORKERS="${OCTANE_TASK_WORKERS:-auto}"
OCTANE_MAX_REQUESTS="${OCTANE_MAX_REQUESTS:-500}"

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
        echo "Launching Laravel Octane (OpenSwoole) on port ${PORT}..."
        exec php /var/www/html/artisan octane:start \
            --server=openswoole \
            --host=0.0.0.0 \
            --port="${PORT}" \
            --workers="${OCTANE_WORKERS}" \
            --task-workers="${OCTANE_TASK_WORKERS}" \
            --max-requests="${OCTANE_MAX_REQUESTS}"
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
