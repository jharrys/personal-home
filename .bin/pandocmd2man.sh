#!/bin/sh

# where $1 is a file called command.7.md
# and $2 would be command.7
pandoc -s -t man $1 -o $2
