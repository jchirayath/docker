#!/bin/bash

PROGNAME=$(basename $0)
echo off

# kafka.sh : Builid Kafka
CONTAINER_NAME=kafka-docker

# Define Working Direcotry
WORKDIR=$HOME/docker/$CONTAINER_NAME

# Get HostName
MY_HOST=`hostname`
# Get HOST Number
MY_NUM="${MY_HOST: -1}"

# Get IP Address
MY_IP=`curl ifconfig.me`

# KAFKA Variables
KAFKA_PORT_NUMBER=

# Change to working directory
cd $WORKDIR


# Build docker container
docker build -t edp/$CONTAINER_NAME .
error_exit "$LINENO: Container build for $CONTAINER_NAME failed !!"

# Create Docker Tar.gz
 docker save edp/$CONTAINER_NAME | gzip > $CONTAINER_NAME.tar.gz
error_exit "$LINENO: Container tarball for $CONTAINER_NAME failed !!"


error_exit()
{
# Exit due to fatal program error
# Display passed parameter
    echo "${PROGNAME}: ${1:-"Unknown Error Occurred !!"}" 1>&2
    exit 1
}