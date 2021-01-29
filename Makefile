
repo = guneycan/php

ifeq (push,$(firstword $(MAKECMDGOALS)))
  TAG := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(TAG):;@:)
endif

build:
	docker build -t $(repo) .

run:
	docker run $(repo)

push:
	docker push $(repo):$(TAG)

shell:
	docker exec -it $(repo) /bin/sh
