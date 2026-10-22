# Laravel + PHP-FPM / Nginx Production Setup

This example demonstrates how to run a production-ready [Laravel](https://laravel.com) application using the `guneycan/php:8.5-fpm` Docker container, which includes PHP-FPM, Nginx, and Supervisord.

## Highlights

- **Single Container Simplicity**: Runs both Nginx and PHP-FPM together under Supervisord, making it ideal for container platforms like Google Cloud Run, AWS App Runner, AWS ECS/Fargate, and Kubernetes.
- **Tuned Nginx**: Gzip compression, fastcgi buffering, security headers, health-check endpoint (`/healthz`), and Laravel routing.
- **Tuned PHP-FPM**: Dynamic process manager configured for predictable workloads with access and error logs piped directly to container stdout/stderr.
- **OPcache & APCu**: Pre-configured OPcache for fast script execution and APCu for high-speed in-process caching.

---

## File Structure

Copy these files into your Laravel project root:

```text
├── .dockerignore
├── Dockerfile
├── docker-compose.yml
└── docker/
    ├── entry.sh
    ├── nginx.conf
    ├── php-fpm.conf
    ├── php.ini
    ├── supervisord.conf
    └── www.conf
```

---

## Container Roles

The `docker/entry.sh` script dynamically switches roles using CLI arguments, `CONTAINER_ROLE`, or `APP_ENV`:

| Role | Trigger | Command Executed |
|---|---|---|
| `web` (default) | Default or `CONTAINER_ROLE=web` | Runs PHP-FPM + Nginx via Supervisord |
| `worker` | `CONTAINER_ROLE=worker` or `APP_ENV=worker` | `php artisan horizon` (if installed) or `php artisan queue:work` |
| `scheduler` | `CONTAINER_ROLE=scheduler` or `APP_ENV=scheduler` | Alpine `crond` invoking `schedule:run` every minute |
| *Custom Command* | e.g. `docker run app php artisan migrate` | Executes custom command directly (`exec "$@"`) |

Before starting a role, `artisan optimize` caches config, routes, views and events and fails the container if it errors. Set `RUN_OPTIMIZATIONS=false` to skip it (the compose file does, because source is live-mounted).

---

## Tuning PHP-FPM Pool (`docker/www.conf`)

By default, the pool uses `pm = dynamic`:

- `pm.max_children = 20`: Maximum concurrent worker processes. Adjust based on available container memory (e.g. allocating ~30-50MB per active PHP child).
- `pm.start_servers = 4`: Workers spawned on startup.
- `pm.min_spare_servers = 2`: Minimum idle workers kept warm.
- `pm.max_spare_servers = 6`: Maximum idle workers before termination.
- `pm.max_requests = 1000`: Recycle workers after 1,000 requests to avoid gradual memory accumulation.

---

## Local Development with Docker Compose

Run the full stack locally:

```bash
docker compose up --build
```

This starts:
- `app`: Web container on `http://localhost:8080`
- `queue`: Background queue worker
- `scheduler`: Background schedule worker
- `postgres`: PostgreSQL database
- `redis`: Redis cache & queue store

---

## Production Deployment (e.g., Google Cloud Run / AWS ECS)

Build and deploy:

```bash
# Build production image
docker build -t my-laravel-fpm:latest .

# Run Web Container
docker run -p 8080:8080 -e CONTAINER_ROLE=web my-laravel-fpm:latest

# Run Queue Worker Container
docker run -e CONTAINER_ROLE=worker my-laravel-fpm:latest
```
