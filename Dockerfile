FROM ubuntu:20.04

LABEL maintainer="forevercyril@cyrilchen1999@outlook.com" \
      summary="Hadoop 集群环境" \
      name="forevercyril/hadoop" \
      version="0.1" 

USER root
WORKDIR /root

# 准备环境hadoop运行环境
COPY ./assets/sources.list /etc/apt

RUN apt-get update && \
    apt-get --no-install-recommends install  -y \
    openssh-server openjdk-11-jdk-headless openssl && \
    apt-get autoremove --yes && \
    apt-get clean autoclean
# 配置SSH    
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# 安装hadoop
ADD assets/hadoop.tar.gz /usr/local
RUN ln -s /usr/local/$(ls /usr/local | grep hadoop-) /usr/local/hadoop

# 配置hadoop环境变量
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_YARN_HOME $HADOOP_HOME

RUN echo export JAVA_HOME=${JAVA_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export HADOOP_HOME=${HADOOP_HOME} >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export HDFS_NAMENODE_USER=root >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export HDFS_NAMENODE_SECURE_USER=root >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export HDFS_SECONDARYNAMENODE_USER=root  >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export HDFS_SECONDARYNAMENODE_SECURE_USER=root  >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export HDFS_DATANODE_USER=root >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export HDFS_DATANODE_SECURE_USER=root >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export YARN_NODEMANAGER_USER=root >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export YARN_RESOURCEMANAGER_USER=root >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo export HADOOP_SHELL_EXECNAME=root >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh

#  添加默认配置文件
COPY ./assets/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY ./assets/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY ./assets/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY ./assets/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY ./assets/hadoop/workers $HADOOP_HOME/etc/hadoop/workers

# 复制启动脚本
COPY ./assets/start.sh /root/
COPY ./assets/stop.sh /root/
COPY ./assets/wordcount.sh /root/
COPY ./assets/enterpoint.sh /

ENTRYPOINT ["/enterpoint.sh"]
CMD [ "bash" ]