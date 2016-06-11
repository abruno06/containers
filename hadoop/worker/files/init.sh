#!/bin/bash

rm /tmp/*.pid

# make sure the core-site host reflect the $HOSTNAME
sed s/HOSTNAME/master/ /usr/local/hadoop/etc/hadoop/core-site.xml.tmp > /usr/local/hadoop/etc/hadoop/core-site.xml


#if [ ! -d /home/hadoop ]
#then
#  $HADOOP_HOME/bin/hdfs namenode -format
#fi

# start consul: wait 60 sec before starting to let consul cluster start
#echo "Wait 60 sec before starting the consul agent"
#sleep 60
#/usr/bin/consul agent -data-dir /tmp/consul -config-dir /etc/consul.d -join consul1 consul2 consul3 &
#/usr/bin/consul members

# start the ssh daemon
service ssh start 

if [[ $1 == "-worker" ]]; then
# on the worker only
# this is the hadoop datanode start 
$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode
# this is the hadoop nodemanager start
$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager
sleep 10
echo "Display Java process"
/usr/bin/jps
#$HADOOP_HOME/sbin/start-yarn.sh
#while true; do sleep 10000; donei
echo "Wait 60 sec before starting the consul agent"
sleep 60
echo "Starting consul Agent..."
#/usr/bin/consul agent -data-dir /tmp/consul -config-dir /etc/consul.d -advertise 0.0.0.0 -join consul1 consul2 consul3
/usr/bin/consul agent  -config-dir /etc/consul.d/client
#/usr/bin/consul members

fi

if [[ $1 == "-bash" ]]; then
/bin/bash
fi
