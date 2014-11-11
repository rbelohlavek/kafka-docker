FROM ubuntu:latest

MAINTAINER marcoy

ENV DEBIAN_FRONTEND noninteractive

RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

RUN locale-gen --no-purge en_US.UTF-8 && dpkg-reconfigure locales
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get install -y curl \
 && apt-get install -y --no-install-recommends software-properties-common \
 && add-apt-repository ppa:webupd8team/java \
 && apt-get update \
 && apt-get install -y --no-install-recommends oracle-java8-installer \
 && curl -sSL https://get.docker.com/ubuntu/ | sudo sh

RUN curl http://mirror.cc.columbia.edu/pub/software/apache/kafka/0.8.1.1/kafka_2.8.0-0.8.1.1.tgz -o /tmp/kafka_2.8.0-0.8.1.1.tgz \
 && tar xfz /tmp/kafka_2.8.0-0.8.1.1.tgz -C /opt

RUN apt-get clean all \
 && apt-get autoremove -y \
 && rm -rf /tmp/kafka* \
 && rm -rf /var/cache/apt/*

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_2.8.0-0.8.1.1
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
CMD start-kafka.sh
