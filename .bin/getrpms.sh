#!/bin/sh

wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/BASE%20RPMS/
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.$1/rpms/
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.$1/server/coreear_1.0.0.0.$1.ear
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.$1/server/config/ALSBCustomizationFile.xml
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.$1/server/config/sbconfig.jar
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.$1/admin/content-tool_1.0.0.0.$1-Content%20Command%20Line%20Loader.zip
wget -N -r -nH -nd --no-parent http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.$1/content/geBaseContent_1.0.0.0.$1.zip
wget -N -r -nH -nd --no-parent -O - http://usihceng01.am.health.ge.com/artifacts/Helix/1.0/1.0.0.0.$1/server/config/HelixCommon.properties.txt | sed -e"s/\${DNS}/$2.eng.med.ge.com/g" > HelixCommon.properties
rm -f index.html*
rm -f *.MD5
