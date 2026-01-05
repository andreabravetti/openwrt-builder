#!/bin/bash

BUILDER_IMAGE=builder-debian12
SOURCE_PATH=../openwrt

[ -d $SOURCE_PATH ] || {
    echo "OpenWrt source not found in $SOURCE_PATH."
    echo "Clone OpenWrt somewhere and personalize this script."
    exit 1
}

docker ps -aq --filter="name=$BUILDER_IMAGE" \
| xargs -r docker stop | xargs -r docker rm

docker run -d --name $BUILDER_IMAGE --rm \
       -v $SOURCE_PATH:/openwrt \
       -it $BUILDER_IMAGE:latest

sleep 1

docker exec -it $BUILDER_IMAGE bash /run.sh
