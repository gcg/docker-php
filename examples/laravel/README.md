# Laravel Production Examples

This directory provides production-grade Docker templates for deploying Laravel applications using `guneycan/php:8.5` images.

## Choose Your Architecture

| Feature | [Laravel Octane (OpenSwoole)](./octane-openswoole) | [Laravel PHP-FPM + Nginx](./fpm) |
|---|---|---|
| **Base Image** | `guneycan/php:8.5-openswoole` | `guneycan/php:8.5-fpm` |
| **Execution Model** | Persistent state in-memory (long-lived processes) | Traditional stateless request-response lifecycle |
| **Performance** | **Ultra-high throughput** (5-10x faster response times) | High throughput, predictable memory footprint |
| **Server Architecture** | Built-in HTTP server (no web server needed) | Nginx reverse proxy + PHP-FPM pool via Supervisord |
| **Best For** | High-traffic APIs, real-time apps, microservices | Standard web apps, apps with global state dependencies |
| **Port** | `8080` | `8080` |

---

## Quick Navigation

- **[Octane + OpenSwoole Setup Guide](./octane-openswoole/README.md)**: Includes multi-stage Dockerfile, container role switching (`web`, `worker`, `scheduler`), and `docker-compose.yml`.
- **[PHP-FPM + Nginx Setup Guide](./fpm/README.md)**: Includes tuned Nginx config, optimized FPM pool, security headers, and single-container Supervisord management.
