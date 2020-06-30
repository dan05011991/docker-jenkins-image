ARG DOCKER_IMAGE=docker:19.03-git
ARG JENKINS_IMAGE=jenkins/jenkins:2.238-centos

FROM $DOCKER_IMAGE
FROM $JENKINS_IMAGE

ARG NODE_VERSION=12.18.2
ARG MAVEN_VERSION=3.5.2
ARG DOCKER_COMPOSE_VERSION=1.25.0
ARG SQL_VERSION=19.6

ENV ORACLE_HOME="/usr/lib/oracle/$SQL_VERSION/client64"
ENV PATH="$ORACLE_HOME:/opt/node-v$NODE_VERSION-linux-x64/bin:/opt/apache-maven-$MAVEN_VERSION/bin:${PATH}"
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib

USER root 

RUN curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

COPY --from=0 /usr/local/bin/docker /usr/bin

RUN yum install -y rpm-build git wget libaio libnsl
# libaio libnsl are for sqlplus

# Node
RUN wget https://nodejs.org/dist/v12.18.2/node-v$NODE_VERSION-linux-x64.tar.xz -O /opt/node-v$NODE_VERSION-linux-x64.tar.xz
RUN tar -C /opt -xvf /opt/node-v$NODE_VERSION-linux-x64.tar.xz
RUN rm /opt/node-v$NODE_VERSION-linux-x64.tar.xz

# Maven
RUN wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz
RUN tar -C /opt -xvf /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz
RUN rm /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz

# Sqlplus
RUN wget https://download.oracle.com/otn_software/linux/instantclient/19600/oracle-instantclient$SQL_VERSION-basic-$SQL_VERSION.0.0.0-1.x86_64.rpm -O /tmp/oracle-basic.rpm
RUN rpm -ivh /tmp/oracle-basic.rpm
RUN rm -f /tmp/oracle-basic.rpm

RUN wget https://download.oracle.com/otn_software/linux/instantclient/19600/oracle-instantclient$SQL_VERSION-sqlplus-$SQL_VERSION.0.0.0-1.x86_64.rpm -O /tmp/sqlplus.rpm
RUN rpm -ivh /tmp/sqlplus.rpm
RUN rm -f /tmp/sqlplus.rpm

#Plugin setup
COPY plugins /usr/share/jenkins/plugins
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins

# Startup scripts
COPY init-scripts/*.groovy /usr/share/jenkins/ref/init.groovy.d/

# Run opts
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8443 --httpsKeyStore="/var/lib/jenkins/keystore" --httpsKeyStorePassword="runescape"
 