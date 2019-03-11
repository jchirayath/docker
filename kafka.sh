#!/bin/bash
# Script to Start and Stop Docker Containers
# Name: kafka

## Global Variables
PROGNAME=$(basename $0)

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
REPOSITORY=

# Get Current HostName
MY_HOST=`hostname`

# Get HOST Number Last digit of the Hostname
MY_NUM="${MY_HOST: -1}"

# Get IP Address
#MY_IP=`curl -s ifconfig.me`
MY_IP=192.168.1.21

# Docker Start Options
#DSTART_OPTIONS='-p 9092:9092 -e KAFKA_ADVERTISED_HOST_NAME=$MY_IP -e KAFKA_ZOOKEEPER_CONNECT=$MY_IP:2181 -v /var/run/docker.sock:/var/run/docker.sock'
DSTART_OPTIONS='-p 9092:9092 -e KAFKA_ADVERTISED_HOST_NAME='$MY_IP' -e KAFKA_ZOOKEEPER_CONNECT='$MY_IP':2181 -v /var/run/docker.sock:/var/run/docker.sock'
# Docker Start Options
#Cat << EOF >> ${DSTART_OPTIONS}
#-p 9092:9092 -e KAFKA_ADVERTISED_HOST_NAME=$MY_IP -e KAFKA_ZOOKEEPER_CONNECT=$MY_IP:2181 -v #/var/run/docker.sock:/var/run/docker.sock
#EOF

# Functions

# Function: Usage - When program is run with any parameters
usage ()
{
  echo "Usage : $PROGNAME {start|stop|reset|build|fetch|image}"
  echo "        Service: $CONTAINER_NAME"
  echo "        start: Starts the docker service"
  echo "        stop: Stops the docker service"
  echo "        restart: restarts the docker service"
  echo "        fetch: Downloads image from local repository"
  echo "        build: Builds the container image from the dockerfile"
  echo "        image: Create a .gz file of the docker container image"
  echo "        rmi: Remove Docker image"
  echo "        clean: Remove Docker image and container"
  exit
}

# Function: error_exit - Generic Error handler
error_exit()
{
# Exit due to fatal program error & Display passed parameter
    echo "${PROGNAME}: ${1:-"Unknown Error Occurred !!"}" 1>&2
    exit 1
}

# Function: start - Generic start handler
start() {
    
    # Run Status function
    if  (status)
    then 
        # Function Stop
        stop
    else
        # Fetch docker
        echo "Do I need to fetch $CONTAINER_NAME ?"
        #fetch
    fi
    
    echo "Starting Docker Container $CONTAINER_NAME"   
    CMD_STAT=$(docker run -d $DSTART_OPTIONS --name $CONTAINER_ALIAS $CONTAINER_NAME:$CONTAINER_TAG)
    if [[ -z $CMD_STAT ]]
    then
        echo "Docker $CONTAINER_NAME FAILED to start!"
        return 0
    else
        echo "Docker $CONTAINER_NAME is running!"
        echo $CMD_STAT\m
        return 1
    fi
}

# Function: status - Generic start handler
status() {
    echo "Checking if Docker container $CONTAINER_NAME exists"
    #CMD_STAT=$(docker inspect -f {{.State}} $CONTAINER_NAME 2>&1)
    #CMD_STAT=$(docker inspect $CONTAINER_NAME 2>&1)
    CMD_STAT=$(docker ps -a | grep $CONTAINER_NAME 2>&1)
    if [[ -z $CMD_STAT ]] 
    then
        echo "Docker $CONTAINER_NAME is not running."
        return 1
    else
        echo "Docker $CONTAINER_NAME is running or image file exits!"
        echo $CMD_STAT
        return 0
    fi
}

# Function: stop - Generic start handler
stop() {
    
    # Run Status function
    if  (status)
    then 
        echo "Found docker service..."
    else
        return 0
    fi
    
    echo "Checking if $CONTAINER_NAME is a restartig service !"
    # Need this line for restarting services
    if [ $D_RESTART_ON = "True" ]
    then
        # Disable Restart Service
        echo "Sending Restart=No for restarting service"
        docker update --restart=no $CONTAINER_NAME
        echo "Waiting a bit for stoping restart service"
        Sleep 10  
    else
        echo "No Restarting service found"  
    fi
    
    echo "Stopping Docker container $CONTAINER_NAME"
    CMD_STAT=$(docker stop $CONTAINER_NAME 2>&1)
    ERROR_STAT=$?
    if [ $ERROR_STAT -eq 0 ] 
    then
        echo "Docker $CONTAINER_NAME is not running or does not exist!"
        return 1       
    else
        echo "Docker $CONTAINER_NAME Stopped!"  
        # Function remover Docker Container
        remove
        return 0
    fi
}

# Function: remove - Generic start handler
remove() {
    echo "Deleteing Docker container $CONTAINER_NAME if exists"
    #CMD_STAT=$(docker rm $CONTAINER_NAME:$CONTAINER_TAG  2>&1)
    CMD_STAT=$(docker rm $CONTAINER_ALIAS  2>&1)
    ERROR_STAT=$?
    if [ $ERROR_STAT -eq 0 ] 
    then
        echo "Docker $CONTAINER_NAME removed!"
        return 0
    else
        echo "Docker $CONTAINER_NAME does not exist!"
        return 1
    fi
}

rmi() {
    echo "Deleteing Docker IMAGE $CONTAINER_NAME:$CONTAINER_TAG if exists"
    CMD_STAT=$(docker rmi $CONTAINER_NAME:$CONTAINER_TAG  2>&1)
    ERROR_STAT=$?
    if [ $ERROR_STAT -eq 0 ] 
    then
        echo "Docker IMAGE for $CONTAINER_NAME Removed!"       
        return 0
    else
        echo "Docker IMAGE for $CONTAINER_NAME does not exist!"
        return 1
    fi
}


# Function: build - Generic build handler
build() {
    echo "Checking if $CONTAINER_DIR exists"
    if [[ $CONTAINER_DIR ]]
    then 
        echo "Building Docker container $CONTAINER_NAME"
        cd $CONTAINER_DIR
        #CMD_STAT=$(docker build -t $CONTAINER_NAME . 2>&1)
        CMD_STAT=$(docker build -t $CONTAINER_NAME:$CONTAINER_TAG . )
        if [[ $CMD_STAT ]] 
        then
            echo "Contianer build of $CONTAINER_NAME Completed!"       
            return 0
        else
            echo "Contianer buiild $CONTAINER_NAME Failed!"
            error_exit "$LINENO"
            return 1
        fi
     else
         echo "Contianer build directory $CONTAINER_DIR does not exit!"
         return 1
     fi
}

# Function: image - Generic image creation handler
image() {
    echo "Exporting container $CONTAINER_NAME"
    CMD_STAT=$(docker image $CONTAINER_NAME | grep $CONTAINER_NAME 2>&1)
    if [[ -z $CMD_STAT ]] 
    then 
        echo "Contianer $CONTAINER_NAME does not exist!"       
        return 1
    else
        echo "Creating .gz image of $CONTAINER_NAME"
        CMD_STAT=$(docker save $CONTAINER_NAME | gzip > $CONTAINER_NAME.gz)
        if [[ -z $CMD_STAT ]]
        then
           echo "Completed building $CONTAINER_NAME"
           return 0
        else
            echo "Contianer export $CONTAINER_NAME Failed!"
            error_exit "$LINENO"
            return 1
        fi
     fi
}


# Function: container - Generic build handler
pull() {  
    if [[ -z $REPOSITORY ]]
    then
       echo "A REPOSITORY has not been defined ! Please define it"
       exit 1
     else
        # Download image from repositiry
        echo "Trying to fetch $CONTAINER_NAME from $REPOSITORY"
        #CMD_STAT=$(docker image $CONTAINER_NAME | grep $CONTAINER_NAME 2>&1)
        CMD_STAT=$(docker pull $REPOSITORY/$CONTAINER_NAME  2>&1)
        ERROR_STAT=$?
        if [ $ERROR_STAT -eq 0 ] 
        then 
            echo "Contianer $CONTAINER_NAME pulled from $REPOSITORY!"       
            return 1
        else
            echo "Contianer $CONTAINER_NAME cout NOT be pulled from $REPOSITORY!"
        fi
     fi
}


# Function: container - Generic build handler
push() {  
    if [[ -z $REPOSITORY ]]
    then
       echo "A REPOSITORY has not been defined ! Please define it"
       return 1     
    fi
    # Push image to repositiry
    echo "Trying to push $CONTAINER_NAME to $REPOSITORY"
    CMD_STAT=$(docker pull $REPOSITORY/$CONTAINER_NAME  2>&1)
    ERROR_STAT=$?
    if [ $ERROR_STAT -eq 0 ] 
    then 
        echo "Contianer $CONTAINER_NAME pushed to $REPOSITORY!"       
        return 1
     else
        echo "Contianer $CONTAINER_NAME could NOT be pushed to $REPOSITORY!"
        return 0
     fi
}

# Main Program starts here
# Check variable condition
case "$1" in
    'start')
            # Start Function
            start
            ;;
    'stop')
            # Stop Function
            stop
            ;;
    'restart')
             # Restart Function
            echo "Restarting Docker container $CONTAINER_NAME"
            stop 
            echo "Waiting for a few seconds"
            sleep 3
            start
            ;;
    'status')
            # Status Function
            status
            ;;
    'build')
            # Build Function
            build
            ;;
    'image')
            # image Function
            image
            ;;
     'pull')
            # fetch Function
            pull
            ;;
     'push')
            # push Function
            push
            ;;
     'remove')
            # remove Function
            remove
            ;;
      'rmi')
            # Remove Image Function
            rmi
            ;;
      'clean')
            # Mulitple  Functions
            stop
            remove
            rmi
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
