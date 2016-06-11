FROM aurelbruno06/hadoop_base
MAINTAINER Aurelien Bruno <aurelbruno06@gmail.com>
WORKDIR /usr/local/hadoop
# Generate SSH Keys for self connect

# Container Image Version --buildarg CONT_IMG_VER will force the update starting that point
ARG CONT_IMG_VER
ENV CONT_IMG_VER ${CONT_IMG_VER:-v0.0.0}

# Add configuration files
ADD files/init.sh /root/init.sh
ADD files/WordCount /root/WordCount
ADD files/500* /root
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
ENV HADOOP_CLASSPATH /usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar
RUN mkdir /root/WordCount/build
RUN $HADOOP_HOME/bin/hadoop com.sun.tools.javac.Main /root/WordCount/*.java -d /root/WordCount/build
RUN /usr/bin/jar -cvf /root/WordCount.jar -C /root/WordCount/build/ . 
 
#CMD ["/usr/sbin/sshd"]
ENTRYPOINT ["/root/init.sh","-jobs"]
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
