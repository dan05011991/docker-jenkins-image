ARG DOCKER_IMAGE=docker:1.10.3-git
ARG JENKINS_IMAGE=jenkins/jenkins:2.219-centos

FROM $DOCKER_IMAGE
FROM $JENKINS_IMAGE

ENV PATH="/opt/node-v12.18.0-linux-x64/bin:/opt/apache-maven-3.5.2/bin:${PATH}"

USER root 

COPY --from=0 /usr/local/bin/docker /usr/bin

RUN yum install -y rpm-build git wget

COPY node-v12.18.0-linux-x64.tar.xz /opt
RUN tar -C /opt -xvf /opt/node-v12.18.0-linux-x64.tar.xz
RUN rm /opt/node-v12.18.0-linux-x64.tar.xz

COPY apache-maven-3.5.2-bin.tar.gz /opt
RUN tar -C /opt -xvf /opt/apache-maven-3.5.2-bin.tar.gz
RUN rm /opt/apache-maven-3.5.2-bin.tar.gz
