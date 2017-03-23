#!/bin/bash

# This script is a front-end script to the manageApplication.py jython script.
# It gets the user/pass/admin_url from user input
# then it calls the script manageApplcation.py
# which is used to deploy the archive.

# TO USE:
# WLHOME: Modify WLHOME to your location of the wls-12.1.3 libraries (you don't have to have weblogic server installed, but you have to have the mentioned libraries to run)
# JAVA_HOME: Create or Modify your JAVA_HOME appropriately
# MANAGEAPPSCRIPT: Modify to point to the location of the manageApplication.py script
# This script expects 3 user inputs:
# -n name of artifact (which should be the name of the full file substracting the extension: i.e., pec-1.0.0.war -> pec-1.0.0)
# -f full path to the artifact on your local machine
# -t the managed server target (i.e., carma1)

[ $# -lt 3 ] && echo "usage: $0 -n NAME -f PATH/TO/FILE -t TARGET" && exit 1

while getopts "n:f:t:" opt; do
  case $opt in
    n)
      NAME=$OPTARG
      ;;
    f)
      FILE=$OPTARG
      ;;
    t)
      TARGET=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      return 125
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      return 125
      ;;
  esac
done

if [ -z "$WL_USER" -o -z "$WL_PASS" -o -z "$WL_ADMIN_URL" ]; then
    echo "Enter WL_USER"
    read WL_USER
    echo "Enter WL_PASS"
    read -s WL_PASS
    echo "Enter WL_ADMIN_URL"
    read WL_ADMIN_URL
    export WL_USER WL_PASS WL_ADMIN_URL
fi

MANAGEAPPSCRIPT=~/.bin/manageApplication.py

WLHOME=/Users/lpjharri/local/appservers/wls-12.1.3

export CLASSPATH=${JAVA_HOME}/lib/tools.jar:${WLHOME}/wlserver/server/lib/weblogic_sp.jar:${WLHOME}/wlserver/server/lib/weblogic.jar:${WLHOME}/wlserver/../oracle_common/modules/net.sf.antcontrib_1.1.0.0_1-0b3/lib/ant-contrib.jar:${WLHOME}/wlserver/modules/features/oracle.wls.common.nodemanager_2.0.0.0.jar:

java -Djava.net.preferIPv4Stack=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.security.TrustKeyStore=DemoTrust -Dweblogic.security.SSL.protocolVersion=TLS1 -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.0 weblogic.WLST $MANAGEAPPSCRIPT -u $WL_USER -p $WL_PASS -a $WL_ADMIN_URL -n $NAME -f $FILE -t $TARGET

