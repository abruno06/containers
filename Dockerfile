FROM aurelbruno06/jdk:1.7
MAINTAINER Aurelien Bruno <aurelbruno06@gmail.com>
#ENV HOME /home/hadoop
# Set the environment variables
ENV HADOOP_VERSION 2.7.2
ENV CONSUL_VERSION 0.6.4
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_INSTALL $HADOOP_HOME
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV HADOOP_YARN_HOME $HADOOP_HOME
ENV YARN_CONF_DIR $HADOOP_YARN_HOME/etc/hadoop
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV PATH $PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

#RUN groupadd -r hadoop && useradd -r --create-home --home-dir $HOME -g hadoop hadoop
#RUN mkdir /home/hadoop && chown hadoop:hadoop /home/hadoop
#USER hadoop

# install Hadoop
WORKDIR /usr/local
RUN wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && tar xzf hadoop-${HADOOP_VERSION}.tar.gz && ln -s hadoop-${HADOOP_VERSION} hadoop && rm -rf hadoop-${HADOOP_VERSION}.tar.gz

#install Consul
RUN wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -O /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip && unzip /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip -d /usr/bin  && rm /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip

#install Consul-template
RUN wget https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip -O /tmp/consul-template_0.14.0_linux_amd64.zip && unzip /tmp/consul-template_0.14.0_linux_amd64.zip -d /usr/bin && rm /tmp/consul-template_0.14.0_linux_amd64.zip 

WORKDIR /usr/local/hadoop

# Generate SSH Keys for self connect
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \\
cp /root/.ssh/id_rsa.pub  /root/.ssh/authorized_keys && \\
chmod 0644 /root/.ssh/authorized_keys

# Container Image Version --buildarg CONT_IMG_VER will force the update starting that point
ARG CONT_IMG_VER
ENV CONT_IMG_VER ${CONT_IMG_VER:-v0.0.0}
RUN echo ${CONT_IMG_VER}
# Add configuration files
ADD files/*.xml $HADOOP_HOME/etc/hadoop/
ADD files/*.tmp $HADOOP_HOME/etc/hadoop/
ADD files/init.sh /root/init.sh
ADD files/sshd_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config

# update the configuration

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\nexport HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=/usr/local/hadoop/lib/native"\n:' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_HOME/etc/hadoop/hadoop-env.sh

#RUN sed s/HOSTNAME/localhost/ $HADOOP_HOME/etc/hadoop/core-site.xml.tmp > $HADOOP_HOME/etc/hadoop/core-site.xml

# format the namenode directory
#RUN $HADOOP_HOME/bin/hdfs namenode -format

# fix x bits on sh files
#RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh
RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh
#RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh

# chmod the installation to be root:root
RUN chown root:root -R $HADOOP_HOME

# start the dfs
#RUN service ssh start && \
#$HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#$HADOOP_HOME/sbin/start-dfs.sh && \
#$HADOOP_HOME/bin/hdfs dfs -mkdir -p /home/hadoop && \
#rm -rf /tmp/*

#RUN service ssh start && \
#$HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#$HADOOP_HOME/sbin/start-dfs.sh && \
#$HADOOP_HOME/bin/hdfs dfs -put $HADOOP_HOME/etc/hadoop/ /home/hadoop && \
#rm -rf /tmp/*



#CMD ["/usr/sbin/sshd"]
ENTRYPOINT ["/root/init.sh","-namenode"]
# SSH port
EXPOSE 22
# Hdfs ports (namenode and secondary namenode)
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 19888
# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
# Consul Ports
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
