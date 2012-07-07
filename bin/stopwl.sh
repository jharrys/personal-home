#!/bin/bash

# Shutdown Weblogic
# $1 - required and is the name of the host
# $2 - if this exists and is "FORCE" then it forces a shutdown
# otherwise it's a graceful shutdown

for x in /usr/sbin/osb-10.3.0.0/wlserver_10.3 /opt/ge/hcit/ecis/pdr/osb/wlserver_10.3 /usr/local/osb10gr3/wlserver_10.3 /opt/ge/hcit/ecis/osb/wlserver_10.3
do
        if [ -d $x ]; then
                WL_HOME="${x}"
                break
        fi
done

# default is graceful shutdown
SHUTDOWNCOMMAND=SHUTDOWN

# if given an argument, and it's FORCE, then make it a forceshutdown
[ -n $2 ] && [ "$2" = "FORCE" ] && SHUTDOWNCOMMAND=FORCESHUTDOWN

# Setup the weblogic environment for this host
. ${WL_HOME}/server/bin/setwlsenv.sh > /dev/null

java weblogic.Admin -url ${1}:7001 -username weblogic -password weblogic ${SHUTDOWNCOMMAND} AdminServer
