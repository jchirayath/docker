#!/bin/bash

echo off
PROGNAME=$(basename $0)

error_exit()
{
# Exit due to fatal program error
# Display passed parameter
    echo "${PROGNAME}: ${1:-"Unknown Error Occurred !!"}" 1>&2
    exit 1
}


# kafka.sh : Builid Kafka
FOLDER_NAME=zookeeper-docker
CONTAINER_NAME=zookeeper

# Define Working Direcotry
WORKDIR=$HOME/docker/$FOLDER_NAME

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
STAGE="Building Docker Container - $CONTAINER_NAME"
echo $STAGE
if (docker build -t $CONTAINER_NAME .)
then
    echo "Completed $STAGE"
else
    error_exit "$LINENO: Failed $STAGE! Aborting."
    exit 1
fi

## Create Docker Tar.gz
#STAGE="Building Docker Tar.gz - $CONTAINER_NAME"
#echo $STAGE
#if (docker save $CONTAINER_NAME | gzip > $CONTAINER_NAME.gz)
#then
#    echo "Completed $STAGE"
#else
#    error_exit "$LINENO: Failed $STAGE! Aborting."
#    exit 1
#fi
