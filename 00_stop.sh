#!/bin/bash

BUILDER_IMAGE=builder-debian12

echo "Stopping ${BUILDER_IMAGE}:"
docker ps -aq --filter="name=$BUILDER_IMAGE" | xargs -r docker stop | xargs -r docker rm
