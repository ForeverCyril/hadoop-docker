#!/usr/bin/env bash

service ssh start

HIGH_LIGHT='\033[1;33m'
CLEAR='\033[0m'

if [ $(hostname) == "hadoop-master" ]; then
    echo -e "${HIGH_LIGHT}Hadoop is starting now. Please Wait.${CLEAR}"
    echo "Formating namenode..."
    $HADOOP_HOME/bin/hadoop namenode -format >> /tmp/startup.log 2>&1
    echo "Starting dfs..."
    $HADOOP_HOME/sbin/start-dfs.sh >> /tmp/startup.log 2>&1
    echo "Starting yarn..."
    $HADOOP_HOME/sbin/start-yarn.sh >> /tmp/startup.log 2>&1
    echo "Starting historyserver..."
    $HADOOP_HOME/bin/mapred --daemon start historyserver >> /tmp/startup.log 2>&1
    echo "Starting finished."
fi

exec "$@"
