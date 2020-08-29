#!/bin/bash

docker build \
    -t ${DOCKER_IMAGE}:${DOCKER_TAG} \
    -f Dockerfile.prod.build \
    .