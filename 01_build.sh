#!/bin/bash

BUILDER_IMAGE=builder-debian12

#BUILD_OPT="--no-cache"
BUILD_OPT=""

./00_stop.sh

echo "Building ${BUILDER_IMAGE}:"
# shellcheck disable=SC2086
docker build $BUILD_OPT --rm -t "${BUILDER_IMAGE}:latest" -f "docker/${BUILDER_IMAGE}.Dockerfile" .
