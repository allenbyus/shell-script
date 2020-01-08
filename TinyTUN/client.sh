#!/bin/bash
VPN=`tinytun -k mypassword123 -c server_ip:5000`
#ip addr add 10.1.0.2/24 brd + dev $VPN
ifconfig $VPN 10.1.0.2 netmask 255.255.255.0
iptables -A POSTROUTING -t nat -s 10.1.0.0/24 -j MASQUERADE -o eth0
