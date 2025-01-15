.PHONY: build build_83 build_84_swoole

build:
	docker buildx build \
		--build-arg PHP_VERSION=8.4 \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.4-openswoole \
		./php/8.4/openswoole/

build_84_swoole:
	docker buildx build \
		--build-arg PHP_VERSION=8.4 \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.4-swoole \
		./php/8.4/swoole/

build_83:
	docker buildx build --build-arg PHP_VERSION=8.3 \
	--push --platform linux/amd64,linux/arm64/v8 \
	-t guneycan/php:8.3 ./php/8.3/

