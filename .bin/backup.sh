#!/bin/bash

# Figure out USB device to backup to
# The USB device labeled JJ for me. In cygwin I can use the /usr/sbin/blkid command to list by label
LABEL_TO_LOOK_FOR="JJ"

echo "Looking for device with label ${LABEL_TO_LOOK_FOR}"

TARGETDEVICE=$(/usr/sbin/blkid -L ${LABEL_TO_LOOK_FOR})

# Make sure we found the device otherwise we exit with an error code of 1
[ $? -gt 0 ] && echo "Unable to find device with label ${LABEL_TO_LOOK_FOR}" && return 1

# If we got this far we found the device, now parse and convert to /cygdrive/x format
TARGETDRIVE=$(cygpath -w ${TARGETDEVICE} | sed -r 's/\\\\\.\\([A-Z]):/\1/' | tr 'A-Z' 'a-z')
TARGETPATH="/cygdrive/${TARGETDRIVE}"
#BACKUPDIR=$HOME/Documents/bkup
BACKUPFILE=$HOME/bin/backup_files.txt

# Notify user we found the device
echo "Found the device labeled ${LABEL_TO_LOOK_FOR} on ${TARGETPATH}"

# [ ! -f $BACKUPFILE ] && echo "$BACKUPFILE does not exist" && exit 1

# exec<$BACKUPFILE

# while read f
#   do
#     #echo "$f ... ${f%%#*}"
#     if [ "${f%%#*}" != "" ]; then
#       WORKINGDIR=${BACKUPDIR}$(dirname ${f%\*})
#       #echo "mkdir -p $WORKINGDIR"
#       mkdir -p $WORKINGDIR
#       #echo "/bin/cp -a -u -v $f ${WORKINGDIR%/}"
#       sudo /bin/cp -a -u -v $f ${WORKINGDIR%/}
#     fi
# done