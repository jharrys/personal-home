#!/bin/bash

# 2017-07-07 by Johnnie H.
# Sets up the environment to be able to run weblogic.* commands.
# If anything, it's the most useful to see if a specific server is up and running the t3/t3s protocol
# and sort of acts like a PING.
#
# It's import to note that this script is meant to be modified as needed for the particular thing
# you need to test. So there are no real options. It's the main entry point for weblogic.* methods.

# TO USE:
# WLHOME: Modify WLHOME to your location of the wls-12.1.3 libraries (you don't have to have weblogic server installed, but you have to have the mentioned libraries to run)
# JAVA_HOME: Create or Modify your JAVA_HOME appropriately

if [ -z "$WL_USER" -o -z "$WL_PASS" -o -z "$WL_ADMIN_URL" ]; then
    echo "Enter WL_USER"
    read WL_USER
    echo "Enter WL_PASS"
    read -s WL_PASS
    echo "Enter WL_ADMIN_URL"
    read WL_ADMIN_URL
    export WL_USER WL_PASS WL_ADMIN_URL
fi

WLHOME=/Users/lpjharri/local/appservers/wls-12.1.3

export CLASSPATH=${JAVA_HOME}/lib/tools.jar:${WLHOME}/wlserver/server/lib/weblogic_sp.jar:${WLHOME}/wlserver/server/lib/weblogic.jar:${WLHOME}/wlserver/../oracle_common/modules/net.sf.antcontrib_1.1.0.0_1-0b3/lib/ant-contrib.jar:${WLHOME}/wlserver/modules/features/oracle.wls.common.nodemanager_2.0.0.0.jar:


# Cancel shutdown
#java -Djava.net.preferIPv4Stack=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.security.TrustKeyStore=DemoTrust -Dweblogic.security.SSL.protocolVersion=TLS1 -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.0 weblogic.Admin -url $WL_ADMIN_URL -username $WL_USER -password $WL_PASS CANCEL_SHUTDOWN

# Force shutdown
#java -Djava.net.preferIPv4Stack=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.security.TrustKeyStore=DemoTrust -Dweblogic.security.SSL.protocolVersion=TLS1 -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.0 weblogic.Admin -url $WL_ADMIN_URL -username $WL_USER -password $WL_PASS FORCESHUTDOWN

# PING server - 2 opt args, number seconds to wait and size of packet
#java -Djava.net.preferIPv4Stack=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.security.TrustKeyStore=DemoTrust -Dweblogic.security.SSL.protocolVersion=TLS1 -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.0 weblogic.Admin -url $WL_ADMIN_URL -username $WL_USER -password $WL_PASS PING 20

# CONNECT server
#java -Djava.net.preferIPv4Stack=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.security.TrustKeyStore=DemoTrust -Dweblogic.security.SSL.protocolVersion=TLS1 -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.0 weblogic.Admin -url $WL_ADMIN_URL -username $WL_USER -password $WL_PASS CONNECT

# LIST server - one optional arg of where to look
java -Djava.net.preferIPv4Stack=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.security.TrustKeyStore=DemoTrust -Dweblogic.security.SSL.protocolVersion=TLS1 -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.0 weblogic.Admin -url $WL_ADMIN_URL -username $WL_USER -password $WL_PASS LIST

# SERVERLOG server - 2 optional args, start time and end time
java -Djava.net.preferIPv4Stack=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.security.TrustKeyStore=DemoTrust -Dweblogic.security.SSL.protocolVersion=TLS1 -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.0 weblogic.Admin -url $WL_ADMIN_URL -username $WL_USER -password $WL_PASS SERVERLOG
