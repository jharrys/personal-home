#!/bin/sh

# $1 is the interface to listen on
# $2 is the mac address in the form of 00:16:36:6B:6C:5A

[ $# -lt 2 ] && echo "usage: $0 interface macaddress" && exit 1

sudo tcpdump -i $1 ether host $2
