#!/bin/bash

BUILDER_IMAGE=builder-debian12

docker ps -aq --filter="name=$BUILDER_IMAGE" \
| xargs -r docker stop | xargs -r docker rm

docker run -d --name $BUILDER_IMAGE --rm \
       -v ../openwrt:/openwrt \
       -it $BUILDER_IMAGE:latest

sleep 1

docker exec -it $BUILDER_IMAGE bash /run.sh
