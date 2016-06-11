#!/bin/bash

rm /tmp/*.pid

# make sure the core-site host reflect the $HOSTNAME
sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.tmp > /usr/local/hadoop/etc/hadoop/core-site.xml


if [ ! -d /home/hadoop ]
then
  $HADOOP_HOME/bin/hdfs namenode -format
fi

# start consul: wait 60 sec before starting to let consul cluster start
#echo "Wait 60 sec before starting the consul agent"
#sleep 60
#/usr/bin/consul agent -data-dir /tmp/consul -config-dir /etc/consul.d -join consul1 consul2 consul3 &
#/usr/bin/consul members

# start the ssh daemon
service ssh start 

if [[ $1 == "-namenode" ]]; then
# on the namenode only
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
netstat -an
#$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh --config $HADOOP_CONF_DIR start historyserver
#while true; do sleep 10000; donei
echo "Wait 60 sec before starting the consul agent"
sleep 60
echo "Starting consul Agent..."
#/usr/bin/consul agent -data-dir /tmp/consul -config-dir /etc/consul.d -advertise 0.0.0.0 -join consul1 consul2 consul3
#/usr/bin/consul agent -config-dir /etc/consul.d/client
#/usr/bin/consul members

CONSUL_TEMPLATE_LOG=debug && /usr/bin/consul-template -consul "consul1:8500" -template "/tmp/slave.tmp:/usr/local/hadoop/etc/hadoop/slaves:/usr/local/hadoop/bin/hadoop dfsadmin -refreshNodes"


fi

if [[ $1 == "-bash" ]]; then
/bin/bash
fi
