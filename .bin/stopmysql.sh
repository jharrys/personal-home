#!/bin/sh

# Stops the Carma application server and services¬

OLDDIR=$(pwd)

echo "Attempting a normal shutdown ..."
sudo /usr/local/mysql/support-files/mysql.server stop > /dev/null 2>&1

pgrep -f -i mysqld > /dev/null
EXITSTATUS=$?

let rcount=0

while [ "$rcount" -lt "3" -a "$EXITSTATUS" -lt "1" ];
do
  echo "Attempting a forceful shutdown ..."
  sudo pkill -9 -a -f mysqld > /dev/null 2>&1
  sleep 5
  pgrep -f -i mysqld > /dev/null 2>&1
  EXITSTATUS=$?
  let rcount=$rcount+1
done

if [ "$rcount" -gt "1" -a "$EXITSTATUS" -lt "1" ];
then
  echo "Unable to stop MySQL. You need to handle it manually."
else
  echo "MySQL stopped."
fi

cd $OLDDIR

