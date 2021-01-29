## Optimized PHP Docker Image

Based on latest php-fpm-alpine image.

Adds compiled php-redis, igbinary and memcached extensions and mysqli pdo pdo_mysql tokenizer xml opcache soap extensions from php-ext-install.

Also includes composer.



```
FROM guneycan/php:latest
```


Specific PHP Versions

For PHP7 `FROM guneycan/php:7`
For PHP8 `FROM guneycan/php:8`
