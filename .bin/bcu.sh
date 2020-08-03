#!/bin/sh
# runs all brew commands to update itself, upgrade installed non-cask apps and clean itself
today="$(date '+%F')"
exists=0

file="$(date '+%F-%H%M')-brew-update.log"
file=/Users/jharrys/tmp/bcu/${file}

for x in /Users/jharrys/tmp/bcu/*.log
do
  if [ ${x%-????-brew-update.log} = "/Users/jharrys/tmp/bcu/$today" ]
  then
    exit 0
  fi
done

mkdir -p $(dirname $file)
echo "*** update of brew" > $file
/usr/local/bin/brew update >> $file
echo "*** upgrade of brew" >> $file
/usr/local/bin/brew upgrade >> $file
echo "*** cleanup of brew" >> $file
/usr/local/bin/brew cleanup >> $file
