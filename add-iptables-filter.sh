#!/bin/bash
doAddIPv4Filter(){
    for one in `cat ${1}`
    do
        iptables -A OUTPUT -d $one -j REJECT
    done
}
doAddIPv6Filter(){
    for one in `cat ${1}`
    do
        ip6tables -A OUTPUT -d $one -j REJECT
    done
}
doDelIPv4Filter(){
    for one in `cat ${1}`
    do
        iptables -D OUTPUT -d $one -j REJECT
    done
}
doDelIPv6Filter(){
    for one in `cat ${1}`
    do
        ip6tables -D OUTPUT -d $one -j REJECT
    done
}
#facebook
doAddIPv4Filter "/etc/v/ips/ipv4-facebook.txt"
doAddIPv6Filter "/etc/v/ips/ipv6-facebook.txt"
#twitter
doAddIPv4Filter "/etc/v/ips/ipv4-twitter.txt"
doAddIPv6Filter "/etc/v/ips/ipv6-twitter.txt"
