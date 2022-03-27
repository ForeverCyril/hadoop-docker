# Hadoop Cluster based on Dokcer（Docker 构建hadoop集群）

## Usage

### build image

you can change the config of hadoop or the apt sourcelist by edit related files in the folder `assets`.
```bash
git clone https://gitee.com/forevercyril/hadoop-docker.git
cd hadoop-docker
# N is the number of the sub node. Default is 3
./build.sh <N>
```

### start container

```bash
# N is the number of the sub node. Default is 3
# Before start you need to build it with same 'N'
./start.sh <N>
```

### stop container

```bash
./stop
```

## Test

After container start up. You can run the `/root/./wordcount.sh` to test the hadoop.
```bash
./wordcount.sh
```