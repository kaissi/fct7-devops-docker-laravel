#!/bin/bash

CMD="${1}" && shift
ARCHS=(${@})

DOCKER_IMAGE="kaissi/devops-docker-laravel"
DOCKER_TAG="multi-arch"

if [ "${CMD}" == "build" ]; then
    if [ -z ${ARCHS} ]; then
        docker build \
            -t ${DOCKER_IMAGE}:${DOCKER_TAG} \
            -f Dockerfile.prod.build \
            .
    else
        for arch in "${ARCHS[@]}"; do
            if [ "${arch}" == "armv7" ]; then
                arch="arm/v7"
            fi
            docker buildx build \
                --pull \
                --load \
                -t ${DOCKER_IMAGE}:${DOCKER_TAG}-${arch////} \
                --platform linux/${arch} \
                -f Dockerfile.prod.multi-arch.build \
                .
        done
    fi
elif [ "${CMD}" == "release" ]; then
    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}-386
    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}-amd64
    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}-arm64
    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}-armv7

    docker manifest create \
        ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-386 \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-amd64 \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-arm64 \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-armv7

    docker manifest annotate \
        ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-386 \
        --arch 386 \
        --os linux

    docker manifest annotate \
        ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-amd64 \
        --arch amd64 \
        --os linux

    docker manifest annotate \
        ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-arm64 \
        --arch arm64 \
        --variant v8 \
        --os linux

    docker manifest annotate \
        ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-armv7 \
        --arch arm \
        --variant v7 \
        --os linux

    docker manifest push \
        ${DOCKER_IMAGE}:${DOCKER_TAG}
fi