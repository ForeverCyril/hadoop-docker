#!/usr/bin/env bash

set -e

N=${1:-3}

NETWORK=hadoop
TAG="forevercyril/hadoop:${N}-node-v0.1"

# check whether the docker network exist and create it if need.
docker network inspect $NETWORK >/dev/null 2>&1 || \
	docker network create --driver=bridge hadoop

# start worker node
i=1
while [ $i -le $N ]
do
	docker rm -f hadoop-worker$i > /dev/null 2>&1
	echo "start hadoop-worker$i container..."
	docker run -itd \
				--net=hadoop \
				--name hadoop-worker$i \
				--hostname hadoop-worker$i \
				$TAG > /dev/null
	i=$(( $i + 1 ))
done 

sleep 1

# start main node
docker rm -f hadoop-master > /dev/null 2>&1
echo "=========================================================="
echo "|| Starting hadoop-master and Attach to it. "
echo "|| Press ctrl-x to detach from it."
echo "=========================================================="
docker run -it \
			--net=hadoop \
			--name hadoop-master \
			--hostname hadoop-master \
			--detach-keys="ctrl-x" \
			$TAG