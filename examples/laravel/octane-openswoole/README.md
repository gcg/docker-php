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
php artisan octane:install --server=openswoole
```

---

## File Structure

Copy these files into your Laravel project root:

```text
├── Dockerfile
├── docker-compose.yml
└── docker/
    ├── entry.sh
    └── php.ini
```

---

## Container Roles

The `docker/entry.sh` script dynamically switches roles using the `CONTAINER_ROLE` or `APP_ENV` environment variables:

| `CONTAINER_ROLE` | Description | Command Executed |
|---|---|---|
| `web` (default) | Runs Octane HTTP server | `php artisan octane:start --server=openswoole --port=8080 ...` |
| `worker` or `queue` | Runs Queue Worker | `php artisan queue:work --tries=3 --timeout=90` |
| `scheduler` | Runs Laravel Schedule daemon | `php artisan schedule:work --no-interaction` |

---

## Configuration Options

You can tune Octane via environment variables:

- `PORT`: Listen port (default: `8080`)
- `OCTANE_WORKERS`: Number of worker processes (default: `auto`, matching CPU cores)
- `OCTANE_TASK_WORKERS`: Number of task worker processes (default: `auto`)
- `OCTANE_MAX_REQUESTS`: Max requests per worker before recycling to prevent memory leaks (default: `500`)
- `RUN_OPTIMIZATIONS`: Set to `true` to execute `artisan config:cache`, `route:cache`, `view:cache`, and `event:cache` on startup

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
