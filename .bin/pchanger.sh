#!/bin/sh

FILES='$HOME/tmp/creds $HOME/tmp/.corkscrew-auth $HOME/tmp/settings.xml $HOME/.npmrc'
SFILES='/etc/auto_johnnie'
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

for sf in $SFILES;
do
  eval sfilename=$sf
  if [ -r "${sfilename}" ];
  then
    sudo sed -i .bak "s/${OLDPASS}/${NEWPASS}/g" $sfilename
  else
    echo "no such file ${sfilename}"
  fi
done

