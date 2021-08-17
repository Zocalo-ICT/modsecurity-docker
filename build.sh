#!/bin/bash
# Prerequisites:
# - Set DOCKER_USER environment variable: export DOCKER_USER='[MY_USER_NAME]'
# - Make sure buildx builder has been set to active before running this
#       docker buildx use [MY_BUILDER_NAME]
# - Log in to dockerhub with docker login -u "$DOCKER_USER"

export VERSION=$(./version.sh v3-nginx/ -vvv)
export NGINX_VERSION=$(grep -m1 "ARG NGINX_VERSION" v3-nginx/Dockerfile | cut -f2 -d= | sed "s/\"//g")
export NGINX_VERSION_ALPINE=$(grep -m1 "ARG NGINX_VERSION" v3-nginx/Dockerfile-alpine | cut -f2 -d= | sed "s/\"//g")
export DOCKER_USER="zocaloict"

## Alpine
    #--platform=linux/amd64,linux/arm64,linux/arm/v7 \
cp ./v3-nginx/Dockerfile-alpine .
docker buildx build \
    -t "${DOCKER_USER}/modsecurity:v$VERSION-nginx_v$NGINX_VERSION_ALPINE-alpine" \
    --platform=$1 \
    -f Dockerfile-alpine \
    --push \
    .
rm ./Dockerfile-alpine


## Regular
    #--platform=linux/amd64,linux/arm64,linux/arm/v7 \
cp ./v3-nginx/Dockerfile .
docker buildx build \
    -t "${DOCKER_USER}/modsecurity:v$VERSION-nginx_v$NGINX_VERSION" \
    --platform=$1 \
    --push \
    .
rm ./Dockerfile

