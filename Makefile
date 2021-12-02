.PHONY: build push

build:
	docker buildx build --push --platform linux/amd64 -t guneycan/php:8.1 .
