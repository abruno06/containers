# Hadoop Cluster

This directory contains all container to make a docker based hadoop cluster

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

