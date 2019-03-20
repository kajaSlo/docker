FROM ubuntu:18.04

MAINTAINER Student Studencki <student.wazny@uj.edu.pl>

RUN useradd ujot --create-home

RUN apt-get update
RUN apt-get install -y --no-install-recommends software-properties-common
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-8-jre
RUN update-alternatives --config java
RUN update-alternatives --config javac

WORKDIR /data

RUN yes | apt-get install curl
RUN apt-get update
RUN apt-get install -y vim unzip curl git

ENV SCALA_VERSION 2.11.7
ENV SBT_VERSION 0.13.11

# Install Scala
RUN \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

RUN echo >> /root/.zshrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.zshrc

CMD zsh

EXPOSE 9000

WORKDIR /home/
RUN git clone https://github.com/playframework/play-scala-slick-example
WORKDIR /home/play-scala-slick-example/
USER ujot
CMD echo "Hello World"
CMD sbt run
