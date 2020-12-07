#!/bin/sh
#

usage="usage:\t$0 \n\t$0 toupdate|tu"

LISTING=$(brew list --cask -1 2>/dev/null)

if [ "$1" = "-h" -o "$1" = "--help" ]; then
  echo $usage && exit 1
elif [ "$1" = "toupdate" -o "$1" = "tu" ]; then
  echo $LISTING |grep -v "\!" |xargs brew info --cask |sed -n -f ~/.bin/brewcask.sed |awk -v RS="" '{ if( $4 == "(auto_updates)" && ($3 != $7) ) print $2, "needs to be upgraded"; else if( $4 != "(auto_updates)" && $3 != $6 ) print $2, "needs to be upgraded" }'

elif [ $# -lt 1 ]; then
  echo $LISTING |grep -v "\!" |xargs brew info --cask |sed -n -f ~/.bin/brewcask.sed
fi

#echo "Apps no longer in homebrew/cask:"
echo $LISTING|grep "\!"
