PHP_VERSION ?= 8.5.12
PHP_MINOR := $(word 1,$(subst ., ,$(PHP_VERSION))).$(word 2,$(subst ., ,$(PHP_VERSION)))
SWOOLE_VERSION ?= v6.2.3
PLATFORMS ?= linux/amd64,linux/arm64/v8
IMAGE_PREFIX ?= guneycan/php
GAR_PREFIX ?= europe-west1-docker.pkg.dev/poltio-164412/php/php
PUSH ?= true
# --load can't import a multi-platform image, so local builds are native-arch only
BUILD = docker buildx build --pull --provenance=false \
	--build-arg PHP_VERSION=$(PHP_VERSION) \
	$(if $(filter true,$(PUSH)),--push --platform $(PLATFORMS),--load)

.PHONY: all build openswoole swoole help

build: openswoole swoole

all: build

openswoole:
	$(BUILD) \
		-t $(IMAGE_PREFIX):$(PHP_MINOR)-openswoole \
		-t $(IMAGE_PREFIX):openswoole \
		-t $(IMAGE_PREFIX):latest \
		-t $(GAR_PREFIX):$(PHP_MINOR)-openswoole \
		./php/$(PHP_MINOR)/openswoole/

swoole:
	$(BUILD) \
		--build-arg SWOOLE_VERSION=$(SWOOLE_VERSION) \
		-t $(IMAGE_PREFIX):$(PHP_MINOR)-swoole \
		-t $(IMAGE_PREFIX):swoole \
		-t $(GAR_PREFIX):$(PHP_MINOR)-swoole \
		./php/$(PHP_MINOR)/swoole/

help:
	@echo "Available make targets:"
	@echo "  make build           - Build and push openswoole and swoole images (PUSH=false loads native-arch locally)"
	@echo "  make openswoole      - Build PHP $(PHP_MINOR) OpenSwoole image"
	@echo "  make swoole          - Build PHP $(PHP_MINOR) Swoole image"
