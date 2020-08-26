.PHONY: default

default: build

build: ## build Docker to local platform (default target)
	scripts/build.sh build

build-%: ## build Docker to a specific platform (386 amd64 arm64 armv7)
	scripts/build.sh build ${*}

build-all: ## build Docker to multiple architectures (386, amd64, arm64 and armv7). You can build for a specific platform using 'make build-armv7', for example
	scripts/build.sh build 386 amd64 arm64 arm/v7

release: build-all ## execute 'build-all', push to Docker Hub and generate manifest
	scripts/build.sh release

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)