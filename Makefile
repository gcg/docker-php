.PHONY: build push build_81

build:
	docker buildx build --build-arg PHP_VERSION=8.2 --push --platform linux/amd64,linux/arm64/v8 -t guneycan/php:8.3 -t guneycan/php:8 -t guneycan/php:latest .

build_82:
	docker buildx build --build-arg PHP_VERSION=8.3 --push --platform linux/amd64,linux/arm64/v8 -t guneycan/php:8.2 .

build_81:
	docker buildx build --build-arg PHP_VERSION=8.1 --push --platform linux/amd64,linux/arm64/v8 -t guneycan/php:8.1 .
