#!/bin/bash

#BUILD_OPT="--no-cache"
BUILD_OPT=""

./00_stop.sh

for dockerfile in "$(dirname "${BASH_SOURCE[0]}")"/docker/*.Dockerfile
do
  name=$(basename "$dockerfile" .Dockerfile)
  echo "Building ${name}:"
  # shellcheck disable=SC2086
  docker build $BUILD_OPT --rm -t "${name}:latest" -f "docker/${name}.Dockerfile" .
done
