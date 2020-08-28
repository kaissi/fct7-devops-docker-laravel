.PHONY: default

# docker manifest command will work with Docker CLI 18.03 or newer
# but for now it's still experimental feature so we need to enable that
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_IMAGE=kaissi/devops-docker-laravel
export DOCKER_TAG=latest

default: build

build: ## build Docker to local platform (default target)
	scripts/build.sh build

build-%: ## build Docker to a specific platform (amd64, arm64, armv7 and armhf)
	scripts/build.sh build ${*}

build-all: ## build Docker to multiple architectures (amd64, arm64, armv7 and armhf). You can build for a specific platform using 'make build-armv7', for example
	scripts/build.sh build amd64 arm64 armv7 armhf

release: build-all ## execute 'build-all', push to Docker Hub and generate manifest
	scripts/build.sh release

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)