#!/bin/bash

set -e

N=${1:-3}

CURRENT_DIR=$(dirname $(readlink -f "$0"))
HADOOP_VERSION=3.3.2

if [ ! -f "$CURRENT_DIR/assets/hadoop.tar.gz" ]; then
	echo "No hadoop archive found at $CURRENT_DIR/assets/hadoop.tar.gz"
	echo "Start Downloading."
	wget -O $CURRENT_DIR/assets/hadoop.tar.gz \
		https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
	echo "Dowloading Finshed."
fi

echo "Start building hadoop with ${N} subnode."

i=1
rm assets/hadoop/workers
while [ $i -le $N ]
do
	echo "hadoop-worker$i" >> assets/hadoop/workers
	((i++))
done 

docker build -t forevercyril/hadoop:$N-node-v0.1 .