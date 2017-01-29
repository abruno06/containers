FROM ubuntu:16.04
MAINTAINER Aurelien Bruno <aurelbruno06@gmail.com>
RUN apt-get update && apt-get install -y ca-certificates curl wget git openssh-client bzip2 file procps && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libmojolicious-perl && rm -fr /var/lib/apt/lists/* 

