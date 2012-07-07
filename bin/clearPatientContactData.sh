#!/bin/bash

NETHOME=/net/ecis204/vol/software/bashpr
cp $NETHOME/bin/clear_patientcontact_data.sql /tmp

echo "Need oracle password: "
su oracle -c "sqlplus / as sysdba @/tmp/clear_patientcontact_data.sql"


## Cleanup
rm -f /tmp/clear_patientcontact_data.sql
