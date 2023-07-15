#!/bin/sh

if [ "$1" == "" ] ; then
   echo "Please specificy server name (e.g. ecis195)"
   exit 1
fi

cp sbconfig.jar sbconfig-$1.jar
mkdir tmp
cd tmp
jar xf ../sbconfig-$1.jar HelixEnvironment
cd HelixEnvironment
mv HelixEnvSettings.Xquery tmp.Xquery
sed -e"s/localhost/$1/g" tmp.Xquery > HelixEnvSettings.Xquery
rm -rf tmp.Xquery
cd ..
jar uf ../sbconfig-$1.jar HelixEnvironment/*
cd ..
rm -rf tmp
