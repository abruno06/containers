FROM aurelbruno06/hadoop_base
MAINTAINER Aurelien Bruno <aurelbruno06@gmail.com>
ENV HADOOP_HOME /usr/local/hadoop
WORKDIR /usr/local/hadoop

# Container Image Version --buildarg CONT_IMG_VER will force the update starting that point
ARG CONT_IMG_VER
ENV CONT_IMG_VER ${CONT_IMG_VER:-v0.0.0}
RUN echo $CONT_IMG_VER
# Add configuration files
ADD files/*.xml $HADOOP_HOME/etc/hadoop/
ADD files/*.tmp $HADOOP_HOME/etc/hadoop/
ADD files/init.sh /root/init.sh
ADD files/sshd_config /root/.ssh/config
ADD consul-template/slave.tmp /tmp
ADD consul.d /etc/consul.d
RUN chmod 600 /root/.ssh/config
RUN echo "" > $HADOOP_HOME/etc/hadoop/slaves
# update the configuration


# format the namenode directory

# fix x bits on sh files
RUN chmod +x ${HADOOP_HOME}/etc/hadoop/*-env.sh



#CMD ["/usr/sbin/sshd"]
ENTRYPOINT ["/root/init.sh","-namenode"]
# SSH port
EXPOSE 22
# Hdfs ports (namenode and secondary namenode)
EXPOSE 50010 50020 50070 50075 50090 8020 9000 
# Mapred ports porthistory
EXPOSE 19888
# Yarn ports
EXPOSE 9001 8030 8031 8032 8033 8040 8042 8088
# Consul Ports
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
