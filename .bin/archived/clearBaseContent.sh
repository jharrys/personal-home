#!/bin/bash

NETHOME=/net/ecis204/vol/software/bashpr
BASECONTENTDIR=/opt/ge/hcit/ecis/domains/content

echo "Running sudo - may need your password"
[ ! "$BASECONTENTDIR" = "" ] && sudo rm -rf ${BASECONTENTDIR}/default
[ ! "$BASECONTENTDIR" = "" ] && sudo rm -rf ${BASECONTENTDIR}/contentRepo/*

cp $NETHOME/bin/clear_base_content.sql /tmp

echo "Need oracle password: "
su oracle -c "sqlplus / as sysdba @/tmp/clear_base_content.sql"


## Cleanup
rm -f /tmp/clear_base_content.sql
