#!/bin/bash
VPN=`tinytun -k mypassword123 -s 5000 -d 'vpn%d'`
#ip addr add 10.1.0.1/24 brd + dev $VPN
ifconfig $VPN 10.1.0.1 netmask 255.255.255.0
iptables -A POSTROUTING -t nat -s 10.1.0.0/24 -j MASQUERADE -o eth0
sleep 3s
ufw route allow in on vpn0 out on eth0
