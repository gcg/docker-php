# Laravel Octane + OpenSwoole Production Setup

This example demonstrates how to run a high-performance [Laravel Octane](https://laravel.com/docs/octane) application using the `guneycan/php:8.5-openswoole` Docker image.

## Why OpenSwoole with Laravel Octane?

- **Persistent Memory**: The application boots once in memory and stays hot across requests, reducing request overhead and boosting throughput by 5-10x compared to traditional PHP-FPM.
- **Coroutines & Concurrency**: Native support for asynchronous I/O and concurrent tasks.
- **Microservice & Serverless Friendly**: Direct HTTP server on port `8080` without requiring a fronting web server in containerized environments like Google Cloud Run, AWS ECS/Fargate, or Kubernetes.

---

## Prerequisites in Laravel

Install Laravel Octane in your Laravel project:

```bash
composer require laravel/octane
php artisan octane:install --server=swoole
```

Octane drives OpenSwoole through its `swoole` server, so `swoole` is the correct value even though the image ships OpenSwoole.

---

## File Structure

Copy these files into your Laravel project root:

```text
├── .dockerignore
├── Dockerfile
├── docker-compose.yml
└── docker/
    ├── entry.sh
    └── php.ini
```

---

## Container Roles

The `docker/entry.sh` script dynamically switches roles using CLI arguments, `CONTAINER_ROLE`, or `APP_ENV`:

| Role | Trigger | Command Executed |
|---|---|---|
| `web` (default) | Default or `CONTAINER_ROLE=web` | `php artisan octane:start --server=swoole --port=8080 ...` |
| `worker` | `CONTAINER_ROLE=worker` or `APP_ENV=worker` | `php artisan horizon` (if installed) or `php artisan queue:work` |
| `scheduler` | `CONTAINER_ROLE=scheduler` or `APP_ENV=scheduler` | Alpine `crond` invoking `schedule:run` every minute |
| *Custom Command* | e.g. `docker run app php artisan migrate` | Executes custom command directly (`exec "$@"`) |

---

## Configuration Options

You can tune Octane via environment variables:

- `PORT`: Listen port (default: `8080`)
- `OCTANE_WORKERS`: Number of worker processes (default: `4`). Size it to the container's CPU limit; Octane's `auto` counts the host's cores, not the container's quota.
- `OCTANE_TASK_WORKERS`: Number of task worker processes (default: `2`)
- `OCTANE_MAX_REQUESTS`: Max requests per worker before recycling to prevent memory leaks (default: `250`)
- `RUN_OPTIMIZATIONS`: Runs `artisan optimize` (config, route, view and event caches) on startup and fails the container if it errors (default: `true`; the compose file sets `false` because source is live-mounted)

---

## Local Development with Docker Compose

Run the entire stack locally:

```bash
docker compose up --build
```

This starts:
- `app`: Laravel Octane on `http://localhost:8080`
- `queue`: Background queue worker
- `scheduler`: Background schedule worker
- `postgres`: PostgreSQL database
- `redis`: Redis cache & queue store

---

## Production Deployment (e.g., Google Cloud Run / AWS ECS)

Build and deploy your image:

```bash
# Build production image
docker build -t my-laravel-app:latest .

# Run Web Container
docker run -p 8080:8080 -e CONTAINER_ROLE=web my-laravel-app:latest

# Run Worker Container
docker run -e CONTAINER_ROLE=worker my-laravel-app:latest
```
