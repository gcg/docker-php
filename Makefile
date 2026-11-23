PHP_VERSION ?= 8.6.0
PHP_MINOR := $(word 1,$(subst ., ,$(PHP_VERSION))).$(word 2,$(subst ., ,$(PHP_VERSION)))
OPENSWOOLE_VERSION ?= 26.11.1
# Swoole does not yet support PHP 8.6; keep it on PHP 8.5 until an upstream release lands
SWOOLE_PHP_VERSION ?= 8.5.13
SWOOLE_PHP_MINOR := $(word 1,$(subst ., ,$(SWOOLE_PHP_VERSION))).$(word 2,$(subst ., ,$(SWOOLE_PHP_VERSION)))
SWOOLE_VERSION ?= v6.2.4
PLATFORMS ?= linux/amd64,linux/arm64/v8
IMAGE_PREFIX ?= guneycan/php
GAR_PREFIX ?= europe-west1-docker.pkg.dev/poltio-164412/php/php
PUSH ?= true
# the default docker-driver builder can't do multi-platform; needs a docker-container builder
BUILDER ?= builderx
# --load can't import a multi-platform image, so local builds are native-arch only
BUILD = docker buildx build --builder $(BUILDER) --pull --provenance=false \
	$(if $(filter true,$(PUSH)),--push --platform $(PLATFORMS),--load)

.PHONY: all build openswoole swoole help

build: openswoole swoole

all: build

openswoole:
	$(BUILD) \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg OPENSWOOLE_VERSION=$(OPENSWOOLE_VERSION) \
		-t $(IMAGE_PREFIX):$(PHP_MINOR)-openswoole \
		-t $(IMAGE_PREFIX):openswoole \
		-t $(IMAGE_PREFIX):latest \
		-t $(GAR_PREFIX):$(PHP_MINOR)-openswoole \
		./php/$(PHP_MINOR)/openswoole/

swoole:
	$(BUILD) \
		--build-arg PHP_VERSION=$(SWOOLE_PHP_VERSION) \
		--build-arg SWOOLE_VERSION=$(SWOOLE_VERSION) \
		-t $(IMAGE_PREFIX):$(SWOOLE_PHP_MINOR)-swoole \
		-t $(IMAGE_PREFIX):swoole \
		-t $(GAR_PREFIX):$(SWOOLE_PHP_MINOR)-swoole \
		./php/$(SWOOLE_PHP_MINOR)/swoole/

help:
	@echo "Available make targets:"
	@echo "  make build           - Build and push openswoole and swoole images (PUSH=false loads native-arch locally)"
	@echo "  make openswoole      - Build PHP $(PHP_MINOR) OpenSwoole $(OPENSWOOLE_VERSION) image"
	@echo "  make swoole          - Build PHP $(SWOOLE_PHP_MINOR) Swoole $(SWOOLE_VERSION) image"
