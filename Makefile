.PHONY: build build_83

build:
	docker buildx build \
		--build-arg PHP_VERSION=8.4 \
		--build-arg INSTALL_NGINX=false \
		--build-arg INSTALL_SUPERVISOR=false \
		--push \
		--platform linux/amd64,linux/arm64/v8 \
		-t guneycan/php:8.4 \
		-t guneycan/php:8 \
		-t guneycan/php:latest \
		.

build_83:
	docker buildx build --build-arg PHP_VERSION=8.3 --push --platform linux/amd64,linux/arm64/v8 -t guneycan/php:8.3 -t guneycan/php:8 -t guneycan/php:latest .

