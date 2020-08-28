#!/bin/bash

CMD="${1}" && shift
ARCHS=(${@})

if [ "${CMD}" == "build" ]; then
    if [ -z ${ARCHS} ]; then
        docker build \
            -t ${DOCKER_IMAGE}:${DOCKER_TAG} \
            -f Dockerfile.prod.build \
            .
    else
        for arch in "${ARCHS[@]}"; do
            local arch_platform=
            if [ "${arch}" == "armv7" ]; then
                arch_platform="arm/v7"
            elif [ "${arch}" == "armhf" ]; then
                arch_platform="arm/v6"
            else
                arch_platform=${arch}
            fi
            docker buildx build \
                --pull \
                --load \
                -t ${DOCKER_IMAGE}:${DOCKER_TAG}-${arch} \
                --platform linux/${arch_platform} \
                -f Dockerfile.prod.build \
                .
        done
    fi
elif [ "${CMD}" == "release" ]; then
    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}-amd64
    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}-arm64
    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}-armv7
    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}-armhf

    docker manifest create --amend ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-amd64 \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-arm64 \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-armv7 \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-armhf \

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

    docker manifest annotate ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_IMAGE}:${DOCKER_TAG}-armhf \
        --arch arm \
        --variant v6 \
        --os linux

    docker manifest push --purge ${DOCKER_IMAGE}:${DOCKER_TAG}
fi