
# ------------------------------------------------------------------------
#
# Copyright 2017 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
#
# ------------------------------------------------------------------------

# set to latest Ubuntu LTS
FROM java:8
MAINTAINER Kiran Kumar Padam

# set user configurations
ARG USER_HOME=/root

# set dependant files directory
ARG FILES=/softwares

RUN echo ${FILES}

# set jdk configurations
ARG JDK=jdk1.8.0*
ARG JAVA_HOME=${USER_HOME}/java

# set wso2 product configurations
ARG WSO2_SERVER=wso2am
ARG WSO2_SERVER_VERSION=2.1.0
ARG WSO2_SERVER_DIST=${WSO2_SERVER}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}

# install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
    curl \
    iproute2 \
    telnet \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# copy the jdk and wso2 product distributions to user's home directory

COPY ${FILES}/${JDK} ${USER_HOME}/java/
RUN chown -R root:root ${USER_HOME}/java/

COPY ${FILES}/${WSO2_SERVER_DIST} ${USER_HOME}/${WSO2_SERVER_DIST}
RUN chown -R root:root ${USER_HOME}/${WSO2_SERVER_DIST}

# copy the postgresql-42.1.4.jar to wso2 lib directory

COPY ${FILES}/postgresql-42.1.4.jar ${USER_HOME}/${WSO2_SERVER_DIST}/repository/components/lib/
RUN chown -R root:root ${USER_HOME}/${WSO2_SERVER_DIST}/repository/components/lib/

# copy the master-datasources.xml to wso2 datasource directory

COPY ${FILES}/master-datasources.xml ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/datasources/
RUN chown -R root:root ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/datasources/


COPY ${FILES}/metrics-datasources.xml ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/datasources/
RUN chown -R root:root ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/datasources/


# set environment variables
ENV JAVA_HOME=${JAVA_HOME} \
    PATH=$JAVA_HOME/bin:$PATH \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME}

RUN chmod -R 777 /root/wso2am-2.1.0

# expose ports
EXPOSE 8280 8243 9763 9443 9099 5672 9711 9611 7711 7611 10397

ENTRYPOINT ${WSO2_SERVER_HOME}/bin/wso2server.sh -Dsetup
