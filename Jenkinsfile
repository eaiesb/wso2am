#!/usr/bin/groovy
pipeline {
agent any
options {
disableConcurrentBuilds()
}
stages {

stage("Build") {
steps { buildApp() }
}
}
}
// steps
def buildApp() {
dir ('eaiesbhub/wso2am/' ) {
def appImage = docker.build("eaiesbhub/wso2am:${BUILD_NUMBER}")
}
}
