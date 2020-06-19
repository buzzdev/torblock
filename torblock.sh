#!/bin/bash

# create a new set for individual IP addresses
#/sbin/ipset -exist -N tor iphash
/sbin/ipset -q create -exist tor hash:ip

# empty the set first
/sbin/ipset flush tor
# get a list of Tor exit nodes that can access $YOUR_IP, skip the comments and read line by line
wget -q https://check.torproject.org/torbulkexitlist?ip=88.198.25.232 -O -|sed '/^#/d' |while read IP
do
  # add each IP address to the new set, silencing the warnings for IPs that have already been added
  /sbin/ipset -q add -exist tor $IP
done
# filter our new set in iptables
/sbin/iptables -A INPUT -m set --match-set tor src -j DROP
