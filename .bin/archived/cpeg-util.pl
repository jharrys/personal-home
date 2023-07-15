#!/usr/bin/perl

use DBI;

my $ip="3.232.235.202"

# if exist /etc/sudoers.tmp
## sleep and keep trying
# else
## touch /etc/sudoers.tmp
## call function to update sudoers
# end if

# function to update sudoers
# if exist users in sudoers, do nothing and report that they are in (listing all)
# else add them and report (listing all)
#
my $db=DBI->connect("dbi:mysql:lab", "root", "") || die( $DBI::errstr . "\n" );
$myquery="select owner,users from machine where ip_address='$ip'";
$mystmt=$db->prepare($myquery);
$mystmt->execute || die "SQL error: $DBI::errstr\n";

@row=$mystmt->fetchrow_array;
print @row;
print "\n";
