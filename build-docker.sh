#!/bin/bash -x

REPO=${1:-"stable"}
if [ "$REPO" != "stable" -a "$REPO" != "testing" ]; then
    echo "Invalid argument! Use 'stable' or 'testing'"
    exit -1
fi

IMAGE="egonzalf/inla-$REPO-rstudio"
hdrfile="./.header"
prevfile="./.last-inla-update-$REPO"
prev=0

curl -D $hdrfile "https://inla.r-inla-download.org/R/$REPO/src/contrib/PACKAGES.gz" >/dev/null 2>&1
last=`awk -F': ' '/Last-Modi/{system("date -d\""$2"\" +%s")}' $hdrfile`
[ -f $prevfile ] && prev=`cat $prevfile`

if [ $last -gt $prev ]; then
    echo "Building $REPO"
    tagdate=$(date -d now +%Y%m%d)
#    docker rmi $IMAGE:latest
    docker build --pull=true --build-arg INLA_REPO="$REPO" --build-arg TIMESTAMP=$last  -t $IMAGE:latest .
    docker tag $IMAGE:latest $IMAGE:$tagdate
    docker push $IMAGE:$tagdate
    docker push $IMAGE:latest
    echo $last > $prevfile
else
    echo "Up to date"
fi
