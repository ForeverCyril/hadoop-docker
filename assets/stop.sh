#!/usr/bin/env bash

$HADOOP_HOME/sbin/stop-dfs.sh
$HADOOP_HOME/sbin/stop-yarn.sh
$HADOOP_HOME/bin/mapred --daemon stop historyserver