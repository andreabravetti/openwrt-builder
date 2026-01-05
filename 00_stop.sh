#!/bin/bash

for dockerfile in "$(dirname "${BASH_SOURCE[0]}")"/docker/*.Dockerfile
do
    name=$(basename "$dockerfile" .Dockerfile)
    echo "Stopping ${name}:"
    docker ps -aq --filter="name=$name" | xargs -r docker stop | xargs -r docker rm
done
