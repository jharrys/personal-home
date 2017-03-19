#!/bin/zsh
#
usage="usage:\t$0 \n\t$0 toupdate|tu"

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
reset=`tput sgr0`

LISTING=$(brew cask ls -1)

if [ "$1" = "-h" -o "$1" = "--help" ]; then
  echo $usage && return 1
elif [ "$1" = "toupdate" -o "$1" = "tu" ]; then
  tput setaf 3
  echo $LISTING |grep -v "\!" |xargs brew cask info |sed -n -f ~/.bin/brewcask.sed |awk -v RS="" '{ if ($3 != $6) print $2, "needs to be upgraded" }'
  tput sgr0

elif [ $# -lt 1 ]; then
  echo $LISTING |grep -v "\!" |xargs brew cask info |sed -n -f ~/.bin/brewcask.sed
fi

echo "Apps no longer in homebrew/cask:"
echo $LISTING|grep "\!"
