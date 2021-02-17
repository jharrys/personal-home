% NETWORKING_NOTES(7) Networking Notes
% Johnnie Harris
% February 16, 2021

# NAME

networking_notes - tips about networking...

# SYNOPSIS

Detailed notes and one liners about networking on the Mac OS, Linux and Unix systems.

# DESCRIPTION

**List Network Hardware (Mac OS)**

: networksetup -listallhardwareports

**Print routing table**

: netstat -r

**multicast dns (mdns, dns-sd): use it to discover and connect to systems on your LAN**

1. list all running services on your LAN

        dns-sd -B _services._dns-sd._udp
1. or list the printers running ipp

        dns-sd -B _ipp._tcp
1. or list computers running sshd, from here grab the *Instance Name*

        dns-sd -B _ssh
1. list the server with a *can be reached at XXXX.local*:22

        dns-sd -L "Instance Name with Spaces" _ssh
1. display v4 ip address for XXXX.local

        dns-sd -G v4 XXXX.local

# SEE ALSO

**dns-sd(1)**, **netstat(1)**, **ifconfig(8)**, **networksetup(8)**
