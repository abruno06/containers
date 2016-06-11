#!/bin/bash

rm /tmp/*.pid

# make sure the core-site host reflect the $HOSTNAME
sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.tmp > /usr/local/hadoop/etc/hadoop/core-site.xml


if [ ! -d /home/hadoop ]
then
  $HADOOP_HOME/bin/hdfs namenode -format
fi


service ssh start 

if [[ $1 == "-namenode" ]]; then
# on the namenode only
$HADOOP_HOME/sbin/start-dfs.sh
while true; do sleep 10000; done
fi

if [[ $1 == "-bash" ]]; then
/bin/bash
fi
if [[ $1 == "-yarn" ]]; then
# on the worker
$HADOOP_HOME/sbin/start-yarn.sh
while true; do sleep 10000; done
fi
