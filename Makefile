.PHONY: build 83 84 swoole openswoole

build: openswoole swoole

openswoole:
	docker buildx build \
		--build-arg PHP_VERSION=8.5 \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.5-openswoole \
		./php/8.5/openswoole/

swoole:
	docker buildx build \
		--build-arg PHP_VERSION=8.5 \
		--build-arg SWOOLE_VERSION=v6.1.4\
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.5-swoole \
		./php/8.5/swoole/

openswoole_84:
	docker buildx build \
		--build-arg PHP_VERSION=8.4 \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.4-openswoole \
		./php/8.4/openswoole/

swoole_84:
	docker buildx build \
		--build-arg PHP_VERSION=8.4 \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.4-swoole \
		./php/8.4/swoole/

83:
	docker buildx build --build-arg PHP_VERSION=8.3 \
	--push --platform linux/amd64,linux/arm64/v8 \
	-t guneycan/php:8.3 ./php/8.3/

