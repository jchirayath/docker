#!/bin/bash

# buildi-run-container.sh : Script to bulid and run the containers
# Kafa container
# Zookeeper
# Kafka Manager

# Define Working Direcotry
WORKDIR=/home/docker

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

# KAFKA_PORT_NUMBER

# Create Docker Container file
cat << EOF > docker-compose.yml
# Working Directory : $WORKDIR
# Hostname: $MY_HOST
# Host Number: $MY_NUM
# IP Address: $MY_IP

version: '2'

services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    ports:
      - '2181:2181'
    volumes:
      - 'zookeeper_data:/bitnami/zookeeper'
  kafka:
    image: 'bitnami/kafka:0'
    ports:
      - '9092:9092'
    volumes:
      - 'kafka_data:/bitnami/kafka'
    environment:
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181

volumes:
  zookeeper_data:
    driver: local
  kafka_data:
    driver: local


EOF

# Create the Docker network
docker network create app-tier --driver bridge

# Docker compose the required containers
docker-compose up

# Docker run Zookeeper
docker run -d --name zookeeper-server \
    --network app-tier \
    bitnami/zookeeper:latest

# Docker run Kafka
docker run -d --name kafka-server \
    --network app-tier \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
    bitnami/kafka:latest


