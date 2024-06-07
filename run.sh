#!/bin/bash
# enrico simonetti - naonis.tech

# check if a port was provided as an argument
if [ -z "$1" ]; then
    echo "No port provided. Using default port 8080."
    PORT=8080
else
    PORT=$1
    if [ "$PORT" -le 1024 ]; then
        echo "Invalid port $PORT. Using default port 8080."
        PORT=8080
    else
        echo "Using provided port: $PORT"
    fi
fi

# define the container name
CONTAINER_NAME="echo-server"

# check if the container is running and stop it
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "Stopping the running container: $CONTAINER_NAME"
    docker stop $CONTAINER_NAME
    if [ $? -ne 0 ]; then
        echo "Failed to stop the Docker container"
        exit 1
    fi
fi

# check if the echo-server image exists and build it
if ! docker image inspect $CONTAINER_NAME:latest > /dev/null 2>&1; then
    echo "Docker image '$CONTAINER_NAME:latest' not found. Building the image..."
    $(dirname "$0")/build.sh
    if [ $? -ne 0 ]; then
        echo "Failed to build the Docker image"
        exit 1
    fi
fi

echo "Running docker container with port $PORT"
CONTAINER_ID=$(docker run -d --rm -e ECHO_SERVER_PORT=$PORT -p $PORT:$PORT --name $CONTAINER_NAME $CONTAINER_NAME)

# wait two seconds to ensure the container starts
sleep 2

# check if the container started successfully
if [ $? -ne 0 ]; then
    echo "Failed to start the Docker container"
    $(dirname "$0")/clean.sh
    exit 1
fi

# capture the container logs
CONTAINER_LOGS=$(docker logs $CONTAINER_ID 2>&1)

# check if the container is still running
if [ $(docker ps -q -f id=$CONTAINER_ID) ]; then
    # follow the Docker container logs
    docker logs -f $CONTAINER_ID
else
    # print the logs if the container has exited
    echo "Container has exited. Printing logs:"
    echo "$CONTAINER_LOGS"
    $(dirname "$0")/clean.sh
fi
