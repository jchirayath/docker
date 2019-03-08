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

# Define BASEDIR
BASE_DIR=$HOME/docker

# run-kafka-manager.sh : Builid Kafka-Manager
CONTAINER_NAME=kafka-manager-docker
CONF_NAME=kafka-manager

# Define Working Direcotry
WORK_DIR=$BASE_DIR/$CONTAINER_NAME
CONF_DIR=$BASE_DIR/$CONF_NAME

# Get HostName
MY_HOST=`hostname`
# Get HOST Number
MY_NUM="${MY_HOST: -1}"

# Get IP Address
MY_IP=`curl -s ifconfig.me`

# Check if Docker is running before starting
STAGE="Checking Docker Container - $CONF_NAME"
echo $STAGE
if (docker inspect -f {{.State}} $CONF_NAME)
then
    echo "$CONF_NAME is running !"
    echo "Stopping $CONF_NAME !"
    
    # Need this line for restarting services
    # Disable Restart Service
    echo "Sending Restart=No for restarting service"
    docker update --restart=no $CONF_NAME
    echo "Waiting a bit for stoping restart service"
    Sleep 10
    
    Echo "Stopping docker service"
    if (docker rm $CONF_NAME)
    then
        echo "Stopped $CONF_NAME !"
    fi
else
    echo "Docker $CONF_NAME is not running"
fi

# Start the Docker Container
STAGE="Starting Docker Container - $CONF_NAME"
echo $STAGE
if (docker run --name $CONF_NAME  --restart always -d -v $CONF_DIR/zoo.cfg:/conf/zoo.cfg edp/$CONTAINER_NAME)
then
    echo "$CONF_NAME is running !"
else
    error_exit "$LINENO: Failed $STAGE! Aborting."
fi
