--   login.sql
--   SQL*Plus user login startup file.
--
--   This script is automatically run after glogin.sql
--
-- To change the SQL*Plus prompt to display the current user,
-- connection identifier and current time.
-- First set the database date format to show the time.
ALTER SESSION SET nls_date_format = 'HH:MI:SS';

-- SET the SQLPROMPT to include the _USER, _CONNECT_IDENTIFIER
-- and _DATE variables.
SET SQLPROMPT "_USER'@'_CONNECT_IDENTIFIER _DATE> "

-- To set the number of lines to display in a report page to 60.
SET PAGESIZE 60

-- To set the number of characters to display on each report line to 132.
SET LINESIZE 132

-- To set the number format used in a report to $99,999.
SET NUMFORMAT $99,999

-- Set wrapper off
SET WRA OFF

-- clear columns formatting
CLEAR COL

-- set some sensible defaults
COL ID FOR 99999
COL NAME FOR A15
COL USERNAME FOR A15
COL EMAIL FOR A15
COL EMAIL_ADDRESS FOR A15
COL PASSWORD FOR A5
COL PASSWD FOR A5

