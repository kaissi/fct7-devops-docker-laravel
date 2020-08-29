#!/bin/bash

ARCHS=(${@})

if [ "${ARCHS}" == "all" ]; then
    ARCHS=(${ARCHS_ALL})
fi

for arch in ${ARCHS[@]}; do
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