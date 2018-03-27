#!/bin/bash

CONTAINER_NAME=${INLA_CONTAINER_NAME:-inla-rstudio}

# MODIFY DEFAULT PASSWORD
unset PASSWORD;
while [ -z $PASSWORD ]; do
	echo "Please enter a new password for user 'rstudio': (if you made a mistake, press CTRL+c)"
	while IFS= read -r -s -n1 pass; do
		if [[ -z $pass ]]; then
			echo
			break
		else
			echo -n '*'
			PASSWORD+=$pass
		fi
	done
done

# VOLUME MOUNT PATH
while [ ! -d "$_path" ]; do
	echo "Type the path you like to use as working directory in RStudio (blank will use current path):"
	read _path
	[ -z $_path ] && _path=$PWD 
done	

# DOCKER
docker stop $CONTAINER_NAME 2>/dev/null

docker run --rm -d --name $CONTAINER_NAME -v $_path:/home/rstudio -p 8787:8787 egonzalf/r-inla:rstudio

echo "rstudio:$PASSWORD" | docker exec -i $CONTAINER_NAME chpasswd


# SUMMARY
IP=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
echo "================================================="
echo "RStudio is running on:"
echo "   http://$IP:8787/ "
echo "   http://localhost:8787/ "
echo ""
echo "to stop RStudio type: docker stop $CONTAINER_NAME"
echo "================================================="

