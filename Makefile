DOCKER_REPO=thrawn01

help: # Display help
	@awk -F ':|##' \
			'/^[^\t].+?:.*?##/ {\
					printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
			}' $(MAKEFILE_LIST)

build-site: ## Run hugo and build the site
	@hugo

build-image: ## Build the image
	docker build -t ${DOCKER_REPO}/hugo-blog:latest .

run: ## Run the docker image
	@echo "Running Image on port 1313"
	-docker rm hugo-blog
	docker run -p 1313:80 --name hugo-blog thrawn01/hugo-blog:latest

publish: ## Push the docker image to dockerhub
	docker push ${DOCKER_REPO}/hugo-blog:latest

.PHONY: build-site build-image publish help run
