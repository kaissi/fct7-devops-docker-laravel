#!/bin/bash

docker build \
    -t ${DOCKER_IMAGE}:${DOCKER_BASE_TAG} \
    -f .scripts/base/Dockerfile \
    .scripts/base