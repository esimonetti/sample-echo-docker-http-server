#!/bin/bash
# enrico simonetti - naonis.tech
docker stop echo-server > /dev/null 2>&1
docker rm echo-server > /dev/null 2>&1
docker rmi echo-server > /dev/null 2>&1
echo Container stopped and image removed, re-run ./build.sh
