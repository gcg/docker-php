PHP_VERSION ?= 8.5
SWOOLE_VERSION ?= v6.1.4
PLATFORMS ?= linux/amd64,linux/arm64/v8
IMAGE_PREFIX ?= guneycan/php
GAR_PREFIX ?= europe-west1-docker.pkg.dev/poltio-164412/php/php

.PHONY: all build openswoole swoole fpm help

build: openswoole swoole fpm

all: build

openswoole:
	docker buildx build --pull \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--push \
		--provenance=false \
		--platform $(PLATFORMS) \
		-t $(IMAGE_PREFIX):8.5-openswoole \
		-t $(IMAGE_PREFIX):openswoole \
		-t $(IMAGE_PREFIX):latest \
		-t $(GAR_PREFIX):8.5-openswoole \
		./php/8.5/openswoole/

swoole:
	docker buildx build --pull \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg SWOOLE_VERSION=$(SWOOLE_VERSION) \
		--push \
		--provenance=false \
		--platform $(PLATFORMS) \
		-t $(IMAGE_PREFIX):8.5-swoole \
		-t $(IMAGE_PREFIX):swoole \
		./php/8.5/swoole/

fpm:
	docker buildx build --pull \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--push \
		--provenance=false \
		--platform $(PLATFORMS) \
		-t $(IMAGE_PREFIX):8.5-fpm \
		-t $(IMAGE_PREFIX):fpm \
		-t $(IMAGE_PREFIX):8.5 \
		./php/8.5/fpm/

help:
	@echo "Available make targets:"
	@echo "  make build       - Build and push openswoole, swoole, and fpm images"
	@echo "  make openswoole  - Build and push PHP 8.5 OpenSwoole image"
	@echo "  make swoole      - Build and push PHP 8.5 Swoole image"
	@echo "  make fpm         - Build and push PHP 8.5 FPM image"
