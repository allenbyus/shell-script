#!/bin/bash
#ifconfig $INTERFACE 10.0.0.1 netmask 255.255.255.0
ip addr add 10.0.0.1/255.255.255.0 dev $VPN
