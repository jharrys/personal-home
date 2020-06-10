#!/bin/sh
# runs all brew commands to update itself, upgrade installed non-cask apps and clean itself
file="$(date '+%F-%H%M')-brew-update.log"
file=/Users/jharris/tmp/${file}
echo "*** update of brew" > $file
/usr/local/bin/brew update >> $file
echo "*** upgrade of brew" >> $file
/usr/local/bin/brew upgrade >> $file
echo "*** cleanup of brew" >> $file
/usr/local/bin/brew cleanup >> $file

