#!/bin/bash

docker volume create \
    --driver local \
    --opt type=none \
    --opt device=$(pwd)/src \
    --opt o=bind \
    laravel-data

docker run \
    --detach \
    --name generate-laravel-files \
    -v laravel-data:/var/www \
    -t ${DOCKER_IMAGE}:${DOCKER_BASE_TAG}

docker rm -f generate-laravel-files

docker volume rm laravel-data

mv ./{LICENSE,README.md} src \
    && for file in $(ls -A src); do mv src/${file} ./; done \
    && rm -rf src
