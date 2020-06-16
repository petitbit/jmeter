.DEFAULT_GOAL := help

cnf ?= docker/compose/.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

REGISTORY_PATH ?= petitbit
IMAGE_NAME ?= ${APP_NAME}
APP_VERSION ?= latest

DANGLING=`docker images --filter "dangling=true" -aq`

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# DOCKER TASKS
all: test build ## go test & go build

.PHONY: build
# Build the container
build: ## Build the container
	docker build --build-arg APP_VERSION=${APP_VERSION} --cache-from $(REGISTORY_PATH)/$(IMAGE_NAME):latest -t $(IMAGE_NAME) -f docker/images/$(IMAGE_NAME)/Dockerfile docker/images/$(IMAGE_NAME)
	docker rmi ${DANGLING} > /dev/null 2>&1

build-nc: ## Build the container without caching
	docker build --build-arg APP_VERSION=${APP_VERSION} --no-cache -t $(IMAGE_NAME) -f docker/images/$(IMAGE_NAME)/Dockerfile docker/images/$(IMAGE_NAME)
	docker rmi ${DANGLING} > /dev/null 2>&1

run: ## Run container on port configured in `default.env`
	docker run -i -t --rm --env-file=./docker/compose/.env --name="$(IMAGE_NAME)" $(IMAGE_NAME)

up: build run ## Run container on port configured in `default.env` (Alias to run)

stop: ## Stop and remove a running container
	docker stop $(IMAGE_NAME); docker rm $(IMAGE_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` and `latest` tagged containers to Docker Hub

# Docker publish
publish: publish-latest publish-version ## Publish the `{version}` and `latest` tagged containers to Docker Hub

publish-latest: tag-latest ## Publish the `latest` taged container to Docker Hub
	@echo 'publish latest to $(REGISTORY_PATH)'
	docker push $(REGISTORY_PATH)/$(IMAGE_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to Docker Hub
	@echo 'publish $(APP_VERSION) to $(REGISTORY_PATH)'
	docker push $(REGISTORY_PATH)/$(IMAGE_NAME):$(APP_VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` and `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(IMAGE_NAME) $(REGISTORY_PATH)/$(IMAGE_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(APP_VERSION)'
	docker tag $(IMAGE_NAME) $(REGISTORY_PATH)/$(IMAGE_NAME):$(APP_VERSION)

version-check: ## Version check
	@echo "VERSION is ${APP_VERSION}"
