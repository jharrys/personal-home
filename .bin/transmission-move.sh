#!/usr/bin/env bash
SOURCE_DIR="${TR_TORRENT_DIR}/${TR_TORRENT_NAME}"
DEST_DIR="/Volumes/iris/videos/"
IDLOGFILE="${TR_TORRENT_DIR}/${TR_TORRENT_NAME}.log"
LOGFILE="${TR_TORRENT_DIR}/transmission.log"

function edate
{
  echo "`date '+%Y-%m-%d %H:%M:%S'`    $1" >> "${LOGFILE}"

}


edate "__________________________NEW TORRENT FINI _______________________"
edate "Version de transmission $TR_APP_VERSION"
edate "Time  $TR_TIME_LOCALTIME"
edate "Directory is $TR_TORRENT_DIR"
edate "Torrent Hash is $TR_TORRENT_HASH"
edate "Torrent ID is $TR_TORRENT_ID"
edate "Torrent name is $TR_TORRENT_NAME "

DIR="${TR_TORRENT_DIR}/${TR_TORRENT_NAME}"
for file in "${SOURCE_DIR}"/*
do
  echo "found $file" >> "${IDLOGFILE}"
  if [ "${file##*.}" == "mp4" ]; then
    cp -v "$file" $DEST_DIR >> "${IDLOGFILE}" 2>&1 &
    RESULT=$?
  fi
  if [ $RESULT -gt 0 ]; then
    edate "cp did not succeed, have to do it manually."
    exit 1
  fi
done
edate "cp succeded!"
exit 0

