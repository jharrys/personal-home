#!/bin/bash

# Duplicates a given directory tree to another directory
# then renames (moves) the original to some backup
# 
# Expects $1 to be the path to the original directory
# Expects $2 to be the path to the new directory

function duptree() {
	if [ -e $1 ]; then
		pushd $1 > /dev/null
		find . -type d -exec mkdir -p ${2}/{} \;
		popd > /dev/null
	else
		echo "Did not find $1, not doing anything"
		exit 1
	fi
}

function rename() {
	mv $1 $2
}

function usage() {
	local APPNAME=`basename $0`
	echo
	echo "usage:"
	echo "$APPNAME SOURCEDIR TARGETDIR SOURCEDIRNEWNAME"
	echo
	exit 1
}

[ $# -lt 3 ] && usage

ORIGINAL="$1"
NEW="$2"
NEWNAME="$3"
CURR=`pwd`

if [ -n "${ORIGINAL##/*}" ]; then
        # relative path given
        ORIGINAL="${CURR}/${ORIGINAL}"
fi

if [ -n "${NEW##/*}" ]; then
        # relative path given
        NEW="${CURR}/${NEW}"
fi

if [ -n "${NEWNAME##/*}" ]; then
        # relative path given
        NEWNAME="${CURR}/${NEWNAME}"
fi

duptree $ORIGINAL $NEW
rename $ORIGINAL $NEWNAME

