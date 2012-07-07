#!/bin/bash

su oracle -c "sqlplus / as sysdba @/net/ecis204/vol/software/bashpr/bin/deleteLocationsData.sql"
