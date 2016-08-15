.PHONY: all build-site build-image publish-image
.DEFAULT_GOAL := all

DOCKER_REPO=thrawn01

build-site:
	@hugo


build: build-site build-image

build-image:
	docker build -t ${DOCKER_REPO}/hugo-blog:latest .

run-image:
	@echo "Running Image on port 1313"
	docker run -p 1313:80 thrawn01/hugo-blog:latest

publish-image: build-image
	docker push ${DOCKER_REPO}/hugo-blog:latest

all: build-site
