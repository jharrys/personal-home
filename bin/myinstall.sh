#!/bin/bash

read -p "Enter build number (i.e., 164): " BUILDNUMBER

# Setup work area
mkdir -p /tmp/work 
cd /tmp/work

# grab the needed artifacts from the artifacts server
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.${BUILDNUMBER}r/server/coreear_1.0.0.0.${BUILDNUMBER}.ear
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.${BUILDNUMBER}/server/config/ALSBCustomizationFile.xml
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.${BUILDNUMBER}/server/config/sbconfig.jar
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.${BUILDNUMBER}/admin/content-tool_1.0.0.0.${BUILDNUMBER}-Content%20Command%20Line%20Loader.zip
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.${BUILDNUMBER}/content/geBaseContent_1.0.0.0.${BUILDNUMBER}.zip
wget -N -r -nH -nd --no-parent -O - http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.${BUILDNUMBER}/server/config/HelixCommon.properties.txt | sed -e"s/\${DNS}/${HOSTNAME}/g" > HelixCommon.properties

# we place the latest 3 builds in /net/ecis204/vol/software/ecis_rpms/daily_builds
cd /net/ecis204/vol/software/ecis_rpms/daily_builds/1.0.0.0.${BUILDNUMBER}/rpms 2>/dev/null

[ "$?" != "0" ] && echo "${BUILDNUMBER} doesn't seem to exist, we only store the last 3 builds" && exit 1

yum localinstall -y --nogpgcheck -x ecis-domains.noarch ecis-*.rpm
yum localinstall -y --nogpgcheck ecis-domains*.rpm

# content install
cd /opt/ge/hcit/ecis/domains/content
mkdir -p distributable/content
mkdir -p distributable/finalZip
mkdir -p distributable/tempImport
mkdir -p geBaseContent
cd geBaseContent/
unzip /tmp/work/geBaseContent_1.0.0.0.${BUILDNUMBER}.zip
cd ..
unzip /tmp/work/content-tool_1.0.0.0.${BUILDNUMBER}-Content\ Command\ Line\ Loader.zip
cd content-tool/
chmod -R 755 *
sed --in-place=.bk "s/localhost/${HOSTNAME}/g" contentLoader.properties
./content-loader.sh

# configure helixcommon.properties
cd /opt/ge/hcit/ecis/domains/EMRDomainSP/lib
cp /tmp/work/HelixCommon.properties .
sed --in-place=.bk1 '/^content\.management\.repository\.location=/d;/^content\.management\.homeDirectory\.location=/d' HelixCommon.properties
sed --in-place=.bk2 's/^#\(content\.management\.repository\.location=.*\)/\1/;s/^#\(content\.management\.homeDirectory\.location=.*\)/\1/' HelixCommon.properties

# modify prod*property files
service adminSP stop;service adminESB stop;service adminNM stop
cd /opt/ge/hcit/ecis/domains/scripts/
sed --in-place=.bk 's+^APPLICATION_HOME=.*+APPLICATION_HOME=/net/ecis204/vol/deploy/helixear+;s+^APPLICATION_PLAN_HOME=.*+APPLICATION_PLAN_HOME=/net/ecis204/vol/deploy/helixear+' prodESBLinux.domain.properties
sed --in-place=.bk 's+^APPLICATION_HOME=.*+APPLICATION_HOME=/net/ecis204/vol/deploy/helixear+;s+^APPLICATION_PLAN_HOME=.*+APPLICATION_PLAN_HOME=/net/ecis204/vol/deploy/helixear+' prodSPLinux.domain.properties

# update both domains
cd /opt/ge/hcit/ecis/domains/scripts
echo "Updating both domains (this may take a while - you will be prompted about 10 minutes into it)"
./startWLST.sh prodESBLinux "weblogic" "weblogic" "updateExistingDomain()"
./startWLST.sh prodSPLinux "weblogic" "weblogic" "updateExistingDomain()"

# start clusters 
echo "Starting the NodeManager and both clusters ..."
service adminNM start; service adminESB start; service adminSP start

echo -e "1) import sbconfig \n2) modify HelixEnvSettings in project explorer\n3) execute customization"
echo -e "4) deploy new ear \n5) restart all domains \n 6) create testuser \n 7) smoke test"
