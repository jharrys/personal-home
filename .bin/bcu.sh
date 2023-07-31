#!/bin/sh
# 7/31/23 changed to not save to file log
# runs all brew commands to update itself, upgrade installed non-cask apps and clean itself
#today="$(date '+%F')"
#exists=0

#file="$(date '+%F-%H%M')-brew-update.log"
#file=/Users/jharris/tmp/bcu/${file}

#for x in /Users/jharris/tmp/bcu/*.log
#do
#  if [ ${x%-????-brew-update.log} = "/Users/jharris/tmp/bcu/$today" ]
#  then
#    exit 0
#  fi
#done

#mkdir -p $(dirname $file)
#echo "*** update of brew" > $file
#/usr/local/bin/brew update -f 2>/dev/null >> $file
/usr/local/bin/brew update -f
#echo "*** upgrade of brew" >> $file
#/usr/local/bin/brew upgrade --greedy 2>/dev/null >> $file
/usr/local/bin/brew upgrade --greedy
#echo "*** cleanup of brew" >> $file
#/usr/local/bin/brew cleanup 2>/dev/null >> $file
/usr/local/bin/brew cleanup
