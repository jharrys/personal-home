#!/bin/bash

# $1 is the new value
# $2-$x are the files

NEWHOST="$1"
shift
FILE="$1"

while [ ! -z "${FILE}" ]; do
	sed "s#\(value=\"jdbc:oracle:thin:@\).*\(:.*:.*\" />\)#\1${NEWHOST}\2#g" ${FILE} > ${FILE}.new
	shift
	FILE="$1"
done
