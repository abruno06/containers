# Hadoop Cluster

This directory contains all container to make a docker based hadoop cluster for test purpose as the volume are not permanant at this stage (see TODO)

* The images
  - base:
  The base image use to build the other image. it is using aurelbruno06/jdk:1.7 images as base
  - namenode:
  The namenode image that will be call master. Handle namenode and the secondarynamenode. This image will look at consul cluster if new work get added and update the slaves files
  - worker:
  The work image. This image will register into the consul cluster in hadoop to allow namenode/master to perform action.
  - consul:
  The consul image build a dedicated consul server image for this hadoop cluster
  - cluster-5:
  This directory contain a basic docker-compose file to test the cluster
  - job
  This image is an example of Java WordCount hadoop client using the aurelbruno06/jdk:1.7 image

* Usage
  - to build the image
  go into the directory and type make
  - to run the cluster
  go into cluster-5.
  run "docker-compose up -d"; this will start the cluster with three consul server, one master and one worker
  	- http://localhost:50070 in order to check if the HDFS part is working
  	- http://localhost:8088 in order to check the Yarn part
	- http://localhost:8500 in order to check consul cluster 
  run "docker-compose scale worker=5"; this should spin-up 4 more worker. Check the HDFS and the consul (delay of 60 second before consul registration) to see if new worker are available

* TODO
 - make a compose file for swarm cluster using vxlan
 - better consul integration
 - allow worker scale down and cleaning in the HDFS
 - make HDFS volume to be permanant
