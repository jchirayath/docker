#!/bin/bash
# Script to Start and Stop Docker Containers
# Name: kafka-manager.sh

## Global Variables
PROGNAME=$(basename $0)

# Get Current HostName
MY_HOST=`hostname`

# Get HOST Number Last digit of the Hostname
MY_NUM="${MY_HOST: -1}"

# Get IP Address
MY_IP=`curl -s ifconfig.me`
#MY_IP=192.168.1.21

# Define BASEDIR 
BASE_DIR=$HOME/docker

# Define the NAME of the container 
CONTAINER_NAME=edp/kafka-manager
CONTAINER_ALIAS=kafka-manager
CONTAINER_TAG=1.0
# Define folder for container files
CONTAINER_FOLDER=kafka-manager-docker

# Build Working Direcotry based on BASE_DIR
WORK_DIR=$BASE_DIR/$CONTAINER_NAME
# Build Container Folder
CONTAINER_DIR=$BASE_DIR/$CONTAINER_FOLDER

# Docker Start Options
D_RESTART_ON="False"
REPOSITORY="cw2edpldvapp004:5000"

# Docker Start Options
DSTART_OPTIONS=""

## Source Docker_Common Functions
if [ -f docker_common.sh ]
then
   . docker_common.sh
else
   echo "Docker Common was not found ! - Please update the path to file"
   exit 1
fi