#!/bin/bash

# Created by Darin Wilcox
# Used for executing Jython scripts. You won't be able to use it verbatim on your local PC, but this script let's you see the required components
# (including classpath information) for running the scripts on your local machine and pushing them out to the servers.

if [ -z "$WL_USER" -o -z "$WL_PASS" -o -z "$WL_ADMIN_URL" ]; then
    echo "Enter WL_USER"
    read WL_USER
    echo "Enter WL_PASS"
    read -s WL_PASS
    echo "Enter WL_ADMIN_URL"
    read WL_ADMIN_URL
    export WL_USER WL_PASS WL_ADMIN_URL
fi

SCRIPT=$1

{
	export CLASSPATH=/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home/lib/tools.jar:/Users/lpjharri/local/appservers/wls-12.1.3/wlserver/server/lib/weblogic_sp.jar:/Users/lpjharri/local/appservers/wls-12.1.3/wlserver/server/lib/weblogic.jar:/Users/lpjharri/local/appservers/wls-12.1.3/wlserver/../oracle_common/modules/net.sf.antcontrib_1.1.0.0_1-0b3/lib/ant-contrib.jar:/Users/lpjharri/local/appservers/wls-12.1.3/wlserver/modules/features/oracle.wls.common.nodemanager_2.0.0.0.jar:

	java -Djava.net.preferIPv4Stack=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.security.TrustKeyStore=DemoTrust -Dweblogic.security.SSL.protocolVersion=TLS1 -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.0 weblogic.WLST $SCRIPT
}
