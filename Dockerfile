ARG DOCKER_IMAGE=docker:19.03-git
ARG JENKINS_IMAGE=jenkins/jenkins:2.238-centos

FROM $DOCKER_IMAGE
FROM $JENKINS_IMAGE

ARG NODE_VERSION=12.18.2
ARG MAVEN_VERSION=3.5.2
ARG DOCKER_COMPOSE_VERSION=1.25.0

ENV PATH="/opt/node-v$NODE_VERSION-linux-x64/bin:/opt/apache-maven-$MAVEN_VERSION/bin:${PATH}"

USER root 

RUN curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

COPY --from=0 /usr/local/bin/docker /usr/bin

RUN yum install -y rpm-build git wget

RUN wget https://nodejs.org/dist/v12.18.2/node-v$NODE_VERSION-linux-x64.tar.xz -O /opt/node-v$NODE_VERSION-linux-x64.tar.xz
RUN tar -C /opt -xvf /opt/node-v$NODE_VERSION-linux-x64.tar.xz
RUN rm /opt/node-v$NODE_VERSION-linux-x64.tar.xz

RUN wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz
RUN tar -C /opt -xvf /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz
RUN rm /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz
