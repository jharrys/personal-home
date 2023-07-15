#!/bin/sh

currdir=$(pwd)

# cd to the dev compose env
cd ~/git/dev-compose-env

# create the sofi docker machine
docker-machine create --driver virtualbox --virtualbox-memory 8192 --virtualbox-cpu-count 4 --virtualbox-disk-size "100000" sofi

# create the dm swap space
./docker-machine-config-swap.sh sofi 20

# set dm environment
eval $(docker-machine env sofi)

# startup the sofi docker-forware executable (forward all docker/container ports to local)
docker-forward start

# initialize all the core databases used by the sofi apps
docker-compose up db-init

cd $currdir
