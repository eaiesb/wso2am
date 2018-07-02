# set to latest Ubuntu LTS
FROM eaiesbhub/wso2am
MAINTAINER manoj Kumar Reddy

# set user configurations
ARG USER_HOME=/root

# set wso2 product configurations
ARG WSO2_SERVER=wso2am
ARG WSO2_SERVER_VERSION=2.1.0
ARG WSO2_SERVER_DIST=${WSO2_SERVER}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}-${WSO2_SERVER_VERSION}

# copy the master-datasources.xml to wso2 datasource directory

COPY ./master-datasources.xml ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/datasources/
RUN chown -R root:root ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/datasources/

COPY ./metrics-datasources.xml ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/datasources/
RUN chown -R root:root ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/datasources/

COPY ./axis2.xml ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/axis2
RUN chown -R root:root ${USER_HOME}/${WSO2_SERVER_DIST}/repository/conf/axis2

RUN chmod -R 777 /root/wso2am-2.1.0

# expose ports
EXPOSE 8280 8243 9763 9443 9099 5672 9711 9611 7711 7611 10397

ENTRYPOINT ${WSO2_SERVER_HOME}/bin/wso2server.sh -Dsetup
