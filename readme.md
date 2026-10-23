# Production-Ready PHP 8.5 Docker Images

[![Docker Pulls](https://img.shields.io/docker/pulls/guneycan/php.svg?style=flat-square)](https://hub.docker.com/r/guneycan/php)
[![PHP Version](https://img.shields.io/badge/PHP-8.5-777BB4?style=flat-square&logo=php&logoColor=white)](https://www.php.net/)
[![OpenSwoole](https://img.shields.io/badge/OpenSwoole-26.2-blue?style=flat-square)](https://openswoole.com/)
[![Alpine Linux](https://img.shields.io/badge/Alpine-Linux-0D597F?style=flat-square&logo=alpinelinux&logoColor=white)](https://alpinelinux.org/)
[![Multi-Arch](https://img.shields.io/badge/Arch-amd64%20%7C%20arm64-blue?style=flat-square)](https://hub.docker.com/r/guneycan/php/tags)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Ultra-lean, high-performance, multi-architecture PHP 8.5 container images based on **Alpine Linux**. Designed specifically for modern cloud deployments—including **Google Cloud Run**, **AWS ECS/Fargate/EKS**, and **Kubernetes**.

---

## Available Variants & Tags

All images are compiled for both `linux/amd64` (Intel/AMD) and `linux/arm64/v8` (Apple Silicon & AWS Graviton).

| Tag | Base | Description | Best For |
|---|---|---|---|
| `guneycan/php:8.5-openswoole`<br>`guneycan/php:openswoole`<br>`guneycan/php:latest` | `cli-alpine` | PHP 8.5 CLI + OpenSwoole 26.2 + Redis + APCu + Composer + Tini | **Laravel Octane**, async microservices, WebSocket servers |
| `guneycan/php:8.5-swoole`<br>`guneycan/php:swoole` | `cli-alpine` | PHP 8.5 CLI + Swoole v6.2 + Redis + APCu + Composer + Tini | Fallback for Octane when OpenSwoole lags behind a PHP release; Hyperf, Mezzio |

---

## Key Features

- **Multi-Arch Native**: First-class builds for `linux/amd64` and `linux/arm64/v8`.
- **Tini Init System**: Every image uses `tini` as `ENTRYPOINT` for proper PID 1 signal forwarding (`SIGTERM`/`SIGQUIT`) and zombie process reaping.
- **Compiled High-Performance Extensions**:
  - `igbinary`: High-efficiency binary serialization format.
  - `redis`: Native PHP Redis client compiled with `enable-redis-igbinary="yes"`.
  - `apcu`: Fast in-pod shared memory cache, perfect for Prometheus metric accumulators and local caching.
  - `opcache`: Pre-installed and ready for JIT / preloading optimizations.
- **Rich Extension Suite**: MySQL (`pdo_mysql`), PostgreSQL (`pdo_pgsql`), SQLite (`pdo_sqlite`), GD (with WebP, JPEG, FreeType), Intl, Zip, BCMath, PCNTL, Sockets, and cURL.
- **Composer 2 Built-in**: Official Composer binary installed at `/usr/local/bin/composer`.

---

## Included PHP Extensions

| Extension | Source | Description / Optimization |
|---|---|---|
| `openswoole` | PECL | High-performance async coroutine runtime (in `*-openswoole`) |
| `swoole` | Source | High-concurrency event-driven network engine (in `*-swoole`) |
| `redis` | PECL | High-performance client compiled with `igbinary` serializer support |
| `igbinary` | PECL | Drop-in replacement for standard PHP serializer, saving space and CPU |
| `apcu` | PECL | In-memory key-value store across worker processes (great for Prometheus) |
| `opcache` | Core | Zend OPcache bytecode optimizer (always built in since PHP 8.5) |
| `pdo_mysql` | Core | PDO MySQL driver |
| `pdo_pgsql` | Core | PDO PostgreSQL driver |
| `gd` | Core | Configured with `--with-freetype`, `--with-jpeg`, `--with-webp` |
| `intl` | Core | Internationalization extension backed by ICU |
| `zip` | Core | Zip archive handling |
| `bcmath` | Core | Arbitrary precision mathematics |
| `pcntl` | Core | Process Control support (forking, signals) |
| `sockets` | Core | Low-level socket communication |
| `mbstring` | Core | Multibyte String support |
| `curl` | Core | Client URL library |

---

## Production Example for Laravel

**[Laravel Octane with OpenSwoole](./examples/laravel/octane-openswoole)**:
   - High-throughput persistent worker model (5-10x throughput boost).
   - Multi-role container entrypoint (`web`, `worker`, `scheduler`).
   - Ready for Google Cloud Run, AWS ECS/Fargate, and Kubernetes.
   - Includes `docker-compose.yml` for local testing.
   - Works unchanged on `guneycan/php:8.5-swoole`: just swap the `FROM` line.

---

## Quick Start

### Run Laravel Octane (OpenSwoole)

```dockerfile
FROM guneycan/php:8.5-openswoole

WORKDIR /var/www/html

COPY . .
RUN composer install --no-dev --optimize-autoloader

ENV PORT=8080
EXPOSE 8080

CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=8080"]
```

---

## Local Development & Image Building

All images are built with `docker buildx` to ensure multi-platform compatibility and fresh base pulls:

```bash
# Build all images (OpenSwoole, Swoole) and push
make build

# Build locally without pushing (native architecture only)
make build PUSH=false

# Build specific variants
make openswoole
make swoole
```

---

## Security & Maintenance

The upstream PHP patch release is pinned via `PHP_VERSION` in the `Makefile` (and the matching `ARG` default in each Dockerfile), so builds are reproducible and never fall below a release with known CVE fixes. Bump it when a new patch lands: `make build PHP_VERSION=8.5.13`.

---

## License

This project is licensed under the [MIT License](LICENSE).
