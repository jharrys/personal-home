#!/bin/bash
LOOP="true"
[ ! -d /home/john/DONE ] && [ ! -d /tmp/DONE ] && exit 1
cd /home/john/DONE
IFS=$'\t\n'
while [ $LOOP ]
do
	for x in `ls`
	do
		mv $x /tmp/DONE
	done
	sleep $1
done
