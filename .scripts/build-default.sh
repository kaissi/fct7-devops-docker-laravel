#!/bin/bash

docker build \
    -t ${DOCKER_IMAGE}:${DOCKER_TAG}-default \
    -f Dockerfile.prod.build \
    .