PACKAGE_NAME := github.com/ulranh/simple-web
GOLANG_CROSS_VERSION ?= v1.20.2
GIT_HASH ?= $(shell git log --format="%h" -n 1)
PORT ?= 8000
DOCKER_REPO ?=localhost:5001

build:
	go build
.PHONY: build

docker:
	docker build --build-arg PORT=${PORT} -t simple-web:$(GIT_HASH) .
	docker tag simple-web:$(GIT_HASH) $(DOCKER_REPO)/simple-web:$(GIT_HASH)
	docker push  $(DOCKER_REPO)/simple-web:$(GIT_HASH)
	sed -i 's/simple-web:.*/simple-web:${GIT_HASH}/' ./simple-web/simple-web.yaml
.PHONY: docker
