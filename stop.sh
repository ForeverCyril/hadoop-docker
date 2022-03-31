#!/bin/bash

N=${1:-3}

docker rm -f hadoop-master &> /dev/null

i=1
while [ $i -le $N ]
do
	docker rm -f hadoop-worker$i &> /dev/null
	i=$(( $i + 1 ))
done 