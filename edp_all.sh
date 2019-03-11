#!/bin/bash
# Script to Start and Stop Docker Containers
# Name: edp_all.sh

## Global Variables
PROGNAME=$(basename $0)

# Function: Usage - When program is run with any parameters
usage ()
{
  echo "Usage : $PROGNAME {start|stop|restart|build|fetch|push|image|rmi|remove|clean}"
  echo ""
  echo "        Program: $PROGNAME"
  echo "        clean: Remove Docker image and container"
  exit
}

APP1=zookeeper.sh
APP2=kafka.sh
APP3=kafka-manager.sh

app_call ()
{
ARG1=$1

./$APP1 $1
./$APP2 $1
./$APP3 $1
}
    

# Main Program starts here
# Check variable condition
case "$1" in
    start)
            # Start Function
            #if [ -f zookeeper.sh ] && [ -f kafka.sh ] && [ -f kafka-manager.sh ]
            #then 
            #    ./zookeeper.sh start 
            #    ./kafka.sh start
            #    ./kafka-manager.sh start
            #else
            #    echo "One of the required startup files are missing !"
            #fi
            app_call start
            ;;
    stop)
            # Stop Function
            app_call stop
            ;;
    restart)
            # Restart Function
            app_call stop
            ;;
    status)
            # Status Function
            app_call status
            ;;
    build)
            # Build Function
            app_call build
            ;;
    image)
            # image Function
            app_call image
            ;;
     pull)
            # fetch Function
            app_call pull
            ;;
     push)
            # push Function
            app_call push
            ;;
     remove|rm)
            # remove Function
            app_call remove
            ;;
      rmi)
            # Remove Image Function
            app_call rmi
            ;;
      clean)
            # Mulitple  Functions
            app_call clean
            ;;
      cleanall)
            # Mulitple  Functions
            docker stop $(docker ps -a -q)
            docker rm $(docker ps -a -q)
            rm *.gz
            ;;
       *)
            # Not valid Parameter Passed
            usage
            echo
            exit 1
            ;;
esac

exit 0
# End of Program


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
CONTAINER_NAME=edp/zookeeper
CONTAINER_ALIAS=zookeeper
CONTAINER_TAG=1.0
# Define folder for container files
CONTAINER_FOLDER=zookeeper-docker

# Build Working Direcotry based on BASE_DIR
WORK_DIR=$BASE_DIR/$CONTAINER_NAME
# Build Container Folder
CONTAINER_DIR=$BASE_DIR/$CONTAINER_FOLDER

# Docker Start Options
DSTART_OPTIONS="-p 2181:2181"

# Docker Start Options
D_RESTART_ON="False"
REPOSITORY="cw2edpldvapp004:5000"

## Source Docker_Common Functions
if [ -f docker_common.sh ]
then
   . docker_common.sh
else
   echo "Docker Common was not found ! - Please update the path to file"
   exit 1
fi