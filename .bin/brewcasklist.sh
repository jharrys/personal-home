#!/bin/sh
#

# source my colors file
. colors.sh

usage="usage:\t$0 \n\t$0 toupdate|tu"

LISTING=$(brew cask ls -1 2>/dev/null)

if [ "$1" = "-h" -o "$1" = "--help" ]; then
  $colored_fg_magenta
  echo $usage && exit 1
elif [ "$1" = "toupdate" -o "$1" = "tu" ]; then
  $colored_fg_yellow
  echo $LISTING |grep -v "\!" |xargs brew cask info |sed -n -f ~/.bin/brewcask.sed |awk -v RS="" '{ if( $4 == "(auto_updates)" && ($3 != $7) ) print $2, "needs to be upgraded"; else if( $4 != "(auto_updates)" && $3 != $6 ) print $2, "needs to be upgraded" }'
  $type_reset

elif [ $# -lt 1 ]; then
  $colored_fg_green
  echo $LISTING |grep -v "\!" |xargs brew cask info |sed -n -f ~/.bin/brewcask.sed
  $type_reset
fi

#echo "Apps no longer in homebrew/cask:"
$colored_fg_red
echo $LISTING|grep "\!"
$type_reset
