ARG DOCKER_IMAGE=docker:1.10.3-git
ARG JENKINS_IMAGE=jenkins/jenkins:2.219-centos

FROM $DOCKER_IMAGE
FROM $JENKINS_IMAGE

ARG DOCKER_COMPOSE_VERSION=1.25.0
ENV PATH="/opt/node-v12.18.0-linux-x64/bin:/opt/apache-maven-3.5.2/bin:${PATH}"

USER root 

RUN curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

COPY --from=0 /usr/local/bin/docker /usr/bin

RUN yum install -y rpm-build git wget

COPY node-v12.18.0-linux-x64.tar.xz /opt
RUN tar -C /opt -xvf /opt/node-v12.18.0-linux-x64.tar.xz
RUN rm /opt/node-v12.18.0-linux-x64.tar.xz

COPY apache-maven-3.5.2-bin.tar.gz /opt
RUN tar -C /opt -xvf /opt/apache-maven-3.5.2-bin.tar.gz
RUN rm /opt/apache-maven-3.5.2-bin.tar.gz
