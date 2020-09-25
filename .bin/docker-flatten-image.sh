#!/bin/sh

image=$1
dockerid=$(docker run -d $image /bin/true)
docker export $dockerid | docker import - $image

