#!/bin/bash

function usage() {
	echo
	echo -e "`basename $0` [-n] -s \"search_param\" [-r \"replace_param\"]"
	echo -e "\t-n:\tmeans dry run, doesn't actually do it"
	echo -e "\tsearch_param:\tshould be the regex to look for & is required"
	echo -e "\treplace_param:\toptional, but replaces the text being removed"
	echo
	echo
	exit 1
}

## Parse args
while [ $1 ]
do
	if [ "$1" = "-n" ]; then
		DRYRUN="yes"
		shift
	elif [ "$1" = "-s" ]; then
		SEARCH="$2"
		shift
		shift
	elif [ "$1" = "-r" ]; then
		REPLACE="$2"
		shift
		shift
	fi
done

[ "${SEARCH}isblank" = "isblank" ] && usage

## Main 
if [ $DRYRUN ]; then
	echo
	echo "-- Dry run, no changes will be made"
	echo "Searching for: <$SEARCH>"
	echo "Replace with : <$REPLACE>"
	echo "Listing will be:"
	echo "----------------"
fi

IFS=$'\t\n'
for x in `ls`
do
	[ -d $x ] && continue
	NAME=$( echo "$x" |sed "s/${SEARCH}/${REPLACE}/g" )
	if [ $DRYRUN ]; then
		echo "$NAME"
	else
		mv "$x" "$NAME"
	fi
done
