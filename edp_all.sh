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

# Define the Application scripts
APP1=zookeeper.sh
APP2=kafka.sh
APP3=kafka-manager.sh

# Function app_call: Function to call services
app_call ()
{
ARG1=$1

if [ -f $APP1 ] && [ -f $APP2 ] && [ -f $APP3 ]
then
    ./$APP1 $1
    ./$APP2 $1
    ./$APP3 $1
else
    echo "One of the required startup files are missing !"
fi
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