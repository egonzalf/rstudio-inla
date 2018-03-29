#!/bin/bash

# VARIABLES
IMAGE="egonzalf/rstudio-inla" # image based on rocker/rstudio
CONTAINER_NAME=${INLA_CONTAINER_NAME:-inla-rstudio}
LOCAL_IP="" # Define an IP address to listen, defaults to 0.0.0.0 (all interfaces)
LOCAL_PORT="" # Define an port number to listen, defaults to 8787

# MODIFY DEFAULT PASSWORD
unset PASSWORD;
while [ -z $PASSWORD ]; do
	echo "Please enter a new password for user 'rstudio': (WARNING: it will be printed on screen at the end.)"
	read -s PASSWORD
done

# VOLUME MOUNT PATH
while [ ! -d "$_path" ]; do
	echo "Type the path you like to use as working directory in RStudio (blank will use current path):"
	read _path
	[ -z $_path ] && _path=$PWD
done

# 
LOCAL_IP=${LOCAL_IP:-0.0.0.0}
LOCAL_PORT=${LOCAL_PORT:-8787}
# DOCKER
# If running, stop it
_status=`docker ps -f name=$CONTAINER_NAME --format "{{.Status}}" | wc -l`
[ $_status -gt 0 ] && docker stop $CONTAINER_NAME

echo "Starting Docker container..."
docker run --rm -d --name $CONTAINER_NAME -v $_path:/home/rstudio -p $LOCAL_IP:$LOCAL_PORT:8787 $IMAGE
echo "rstudio:$PASSWORD" | docker exec -i $CONTAINER_NAME chpasswd

# SUMMARY
IP=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
IP=${LOCAL_IP:-0.0.0.0}
IP=${IP:-0.0.0.0}
echo "================================================="
echo "RStudio is running on:"
echo "   http://$IP:$LOCAL_PORT/"
echo "   http://localhost:$LOCAL_PORT/"
echo "username:rstudio"
echo "password:$PASSWORD"
echo ""
echo "to stop RStudio type: docker stop $CONTAINER_NAME"
echo "================================================="
