## Optimized PHP Docker Image

Production ready PHP FPM/Nginx Docker container image based on Alpine Linux.

Includes MySQLi, PDO, XML, Soap, GD, ZIP and Intl official extensions plus compiled memcached, igbinary and phpredis for better performance.

You can find an example for production under [examples/laravel](https://github.com/gcg/docker-php/blob/master/examples/laravel/readme.md)

### PHP 8.2

```
FROM guneycan/php:8.2
```

### PHP 8.1

```
FROM guneycan/php:8.1
```

### PHP 8.0

```
FROM guneycan/php:8
```

### PHP 7

```
FROM guneycan/php:8
```
