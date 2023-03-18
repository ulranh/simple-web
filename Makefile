PACKAGE_NAME := github.com/ulranh/simple-web
GOLANG_CROSS_VERSION ?= v1.20.2
GIT_HASH ?= $(shell git log --format="%h" -n 1)
PORT ?= 8000
DOCKER_REPO ?=localhost:5001

build:
	go build
.PHONY: build

client:
	npm --prefix ./client install
	npm --prefix ./client run build
.PHONY: client

generate-build:
	go generate cmd/assets.go
	go build
.PHONY: generate-build

docker-build:
	docker build --build-arg PORT=${PORT} -t simple-web:$(GIT_HASH) .
.PHONY: docker-build

docker-run:
	docker run -d --name=saphistory -p $(PORT):${PORT} -v $(DBSTORE):/app/badger saphistory:$(VERSION)
.PHONY: docker-run

docker-tag-version:
	docker tag saphistory:$(VERSION) $(DOCKER_REPO)/saphistory:$(VERSION)
.PHONY: docker-tag-version

docker-push-version:
	docker push  $(DOCKER_REPO)/saphistory:$(VERSION)
.PHONY: docker-push-version

docker:
	docker build --build-arg PORT=${PORT} -t simple-web:$(GIT_HASH) .
	docker tag simple-web:$(GIT_HASH) $(DOCKER_REPO)/simple-web:$(GIT_HASH)
	docker push  $(DOCKER_REPO)/simple-web:$(GIT_HASH)
	sed -i 's/simple-web:.*/simple-web:${GIT_HASH}/' ./simple-web/simple-web.yaml
.PHONY: docker
