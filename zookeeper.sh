#!/bin/bash
# Script to Start and Stop Docker Containers
# Name: zookeeper.sh

## Global Variables
PROGNAME=$(basename $0)

# Get Current HostName
MY_HOST=`hostname`

# Get HOST Number Last digit of the Hostname
MY_NUM="${MY_HOST: -1}"

# Get IP Address
#MY_IP=`curl -s ifconfig.me`
MY_IP=10.23.53.85

# Define BASEDIR 
#BASE_DIR=$HOME/docker
BASE_DIR=$(pwd)

# Define the NAME of the container 
CONTAINER_NAME=mufgdev/zookeper
CONTAINER_ALIAS=zookeeper
CONTAINER_TAG=latest
# Define folder for container files
CONTAINER_FOLDER=zookeeper-docker

# Build Working Direcotry based on BASE_DIR
WORK_DIR=$BASE_DIR/$CONTAINER_NAME
# Build Container Folder
CONTAINER_DIR=$BASE_DIR/$CONTAINER_FOLDER

# Docker Start Options
DSTART_OPTIONS="-p 0.0.0.0:2181:2181"

# Docker Start Options
D_RESTART_ON="False"
#REPOSITORY="cw2edpldvapp004:5000"

## Source Docker_Common Functions
if [ -f docker_common.sh ]
then
   . docker_common.sh
else
   echo "Docker Common was not found ! - Please update the path to file"
   exit 1
fi
