.PHONY: build build_83 build_84_swoole build_84_openswoole

build: build_84_swoole build_84_openswoole

build_84_swoole:
	docker buildx build \
		--build-arg PHP_VERSION=8.4 \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.4-swoole \
		-t guneycan/php:8-swoole \
		-t guneycan/php:swoole \
		./php/8.4/swoole/


build_84_openswoole:
	docker buildx build \
		--build-arg PHP_VERSION=8.4 \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.4-openswoole \
		-t guneycan/php:8 \
		-t guneycan/php:latest \
		-t guneycan/php:openswoole \
		-t guneycan/php:8-openswoole \
		./php/8.4/openswoole/


build_83:
	docker buildx build --build-arg PHP_VERSION=8.3 \
	--push --platform linux/amd64,linux/arm64/v8 \
	-t guneycan/php:8.3 ./php/8.3/

