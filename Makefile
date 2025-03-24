.PHONY: build 83 swoole openswoole

build: openswoole swoole

openswoole:
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

swoole:
	docker buildx build \
		--build-arg PHP_VERSION=8.4 \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.4-swoole \
		-t guneycan/php:8-swoole \
		-t guneycan/php:swoole \
		./php/8.4/swoole/

83:
	docker buildx build --build-arg PHP_VERSION=8.3 \
	--push --platform linux/amd64,linux/arm64/v8 \
	-t guneycan/php:8.3 ./php/8.3/

