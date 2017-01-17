#!/bin/sh

FILES='$HOME/tmp/creds $HOME/tmp/.corkscrew-auth $HOME/tmp/settings.xml $HOME/.npmrc'
OLDPASS=$1
NEWPASS=$2

for f in $FILES;
do
  eval filename=$f
  if [ -r "${filename}" ];
  then
    sed -i .bak "s/${OLDPASS}/${NEWPASS}/g" $filename
  else
    echo "no such file ${filename}"
  fi
done
