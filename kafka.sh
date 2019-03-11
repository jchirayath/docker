#!/bin/bash
# Script to Start and Stop Docker Containers
# Name: kafka.sh

## Global Variables
PROGNAME=$(basename $0)

# Get Current HostName
MY_HOST=`hostname`

# Get HOST Number Last digit of the Hostname
MY_NUM="${MY_HOST: -1}"

# Get IP Address
MY_IP=`curl -s ifconfig.me`
MY_IP=10.4.1.150

# Define BASEDIR 
BASE_DIR=$HOME/docker

# Define the NAME of the container 
CONTAINER_NAME=edp/kafka
CONTAINER_ALIAS=kafka
CONTAINER_TAG=1.0
# Define folder for container files
CONTAINER_FOLDER=kafka-docker

# Build Working Direcotry based on BASE_DIR
WORK_DIR=$BASE_DIR/$CONTAINER_NAME
# Build Container Folder
CONTAINER_DIR=$BASE_DIR/$CONTAINER_FOLDER

# Docker Start Options
D_RESTART_ON="False"
REPOSITORY="cw2edpldvapp004:5000"

# Docker Start Options
#DSTART_OPTIONS='-p 9092:9092 -e KAFKA_ADVERTISED_HOST_NAME=$MY_IP -e KAFKA_ZOOKEEPER_CONNECT=$MY_IP:2181 -v /var/run/docker.sock:/var/run/docker.sock'
DSTART_OPTIONS='-p 9092:9092 -e KAFKA_ADVERTISED_HOST_NAME='$MY_IP' -e KAFKA_ZOOKEEPER_CONNECT='$MY_IP':2181 -v /var/run/docker.sock:/var/run/docker.sock'

## Source Docker_Common Functions
if [ -f docker_common.sh ]
then
   . docker_common.sh
else
   echo "Docker Common was not found ! - Please update the path to file"
   exit 1
fi
