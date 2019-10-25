#!/usr/bin/env bash -x

NAME_BUILD="analytics-server-build"
NAME_RUN="analytics-server-run"
PORT=8083

## Get the latest changes
# git reset --hard
# git pull

## Ensure old container is stopped
RUNNING_DOCKER_ID=$(docker ps -q --filter "ancestor=$NAME_RUN")

if [[ -n "$RUNNING_DOCKER_ID" ]]; then
	docker stop $RUNNING_DOCKER_ID -t 1 || true
	docker rm $RUNNING_DOCKER_ID || true
fi
docker build -t $NAME_BUILD -f Dockerfile-tools .
docker run -v $PWD:/swift-project -w /swift-project $NAME_BUILD /swift-utils/tools-utils.sh build release
docker build -t $NAME_RUN .
docker run -p $PORT:$PORT -itd $NAME_RUN

