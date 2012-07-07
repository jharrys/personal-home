#!/bin/bash
BACKUPDIR=$HOME/Documents/bkup
BACKUPFILE=$HOME/bin/backup_files.txt

[ ! -f $BACKUPFILE ] && echo "$BACKUPFILE does not exist" && exit 1

exec<$BACKUPFILE

while read f
  do
    #echo "$f ... ${f%%#*}"
    if [ "${f%%#*}" != "" ]; then
      WORKINGDIR=${BACKUPDIR}$(dirname ${f%\*})
      #echo "mkdir -p $WORKINGDIR"
      mkdir -p $WORKINGDIR
      #echo "/bin/cp -a -u -v $f ${WORKINGDIR%/}"
      sudo /bin/cp -a -u -v $f ${WORKINGDIR%/}
    fi
done