% DIRUTIL(7) MacOS Directorty Utility
% Johnnie Harris
% June 26, 2020

# NAME

dirutil - notes on macos' directory utility

# SYNOPSIS

Directory Utility.app ...

# DESCRIPTION

MacOS offers two utilities for working with directories such as LDAP or Microsoft's AD.

Note that MacOS is also based on NextStep which used Netinfo in the beginning.

Utility 1 is *Directory Utility.app* which is a UI based utility. It automatically uses
Kerberos, so you can connect to NTML/KRB naturally. You can look in the log file krb5.log
for details about how it's trying to login.

With *Directory Utility.app* you must first __bind__ to the domain. For example the domain
for the church is *ldschurch.org*. Use your federated credentials to bind and then Active Directory
should be enabled and you should be able to execute searches within the UI app.

Utility 2 is *dscl* which is equivalent to the old netinfo. Note that once you bind with the UI tool
you can figure out the LDS domain. The command below lists all users within the LDS AD domain.

    dscl "Active Directory/LDS/All Domains" -list /Users

In addition, *dscl* is interactive in the cli. Just type the command without parameters and you'll
be in interactive mode. You can use the help to figure out details.

# OPTIONS

# SEE ALSO

`dscl` (1).
