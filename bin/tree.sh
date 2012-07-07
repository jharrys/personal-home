#!/bin/sh
DIR="$1"
echo
if [ "$DIR" == "" ]  #if parameter exists, use as base folder
	   then DIR="."
fi

#find "$DIR" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
find "$DIR" -print | sed -e 's;[^/]*/;|-- ;g;s; --|; |;g'

echo
exit
