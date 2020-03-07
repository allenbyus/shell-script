#!/bin/bash
doAddChinaRoute(){
    for line in `cat /etc/v/cidr-cn.txt`
    do
        ip route add $line via 156.96.153.1 dev eth0
    done
}
doDelChinaRoute(){
    for line in `cat /etc/v/cidr-cn.txt`
    do
        ip route del $line via 156.96.153.1 dev eth0
    done
}
doUpdate(){
    pkill tinytun
    VPN=`tinytun -k mypassword123 -c ${1}:10001 -d 'tap%d'`
    sleep 3s
    ifconfig $VPN 10.1.0.2 netmask 255.255.255.0
    ip route add 10.1.0.0/24 via 10.1.0.1 dev $VPN
    echo $VPN>/etc/v/vpn.txt
    iptables -A POSTROUTING -t nat -s 10.1.0.0/24 -j MASQUERADE -o eth0
    ip route add 59.120.227.144/32 via 156.96.153.1 dev eth0
    ip route add 47.240.172.156/32 via 156.96.153.1 dev eth0
    ip route add ${1} via 156.96.153.1 dev eth0
    ip route add 180.215.255.99 via 156.96.153.1 dev eth0 #额外路由(dns)
    ip route add 180.215.255.88 via 156.96.153.1 dev eth0 #额外路由(dns)
    ip route del ${2} via 156.96.153.1 dev eth0
    ip route del default
    ip route add default via 10.1.0.1 dev $VPN
    doAddChinaRoute
}
doSourceNetworkRoute(){
    pkill tinytun
    sleep 3s
    ip route del default
    ip route add default via 156.96.153.1 dev eth0
    echo 1.1.1.1>/etc/v/ddnsip.txt
    doDelChinaRoute
    echo "已恢复源网路路由"
}
VPN=`sed -n 1p /etc/v/vpn.txt`
network_check=$(curl --interface $VPN -s -w %{http_code} ip.sb)
if [[ "${network_check}" == "000" ]];then
    echo "网络连接：fail"
    doSourceNetworkRoute
else
    echo "网络连接：OK"
fi
nslookupInfo=`nslookup hka.9.dnsabr.com | grep 'Address: '`
ddns_ip=`echo ${nslookupInfo#* }`
old_ip=`sed -n 1p /etc/v/ddnsip.txt`
server_avaliable_check_condition="Connection timed out"
server_avaliable_check=$(nc -zvw3 ${ddns_ip} 10001 2>&1)
if [[ ${server_avaliable_check} =~ ${server_avaliable_check_condition} ]]
then
    echo "服务端服务未开启！"
    exit
else
    echo "服务端服务已开启！"
fi
echo "记录中的地址：${old_ip}!"
if [ "${old_ip}" = "${ddns_ip}" ];then
    echo "有效，IP：${ddns_ip}"
else
    echo "过期，新IP：${ddns_ip}!"
    doUpdate "${ddns_ip}" "${old_ip}"
    echo $ddns_ip > /etc/v/ddnsip.txt
fi
if ping -c 1 10.1.0.1 &> /dev/null
then
    echo "ping对端网路:OK"
else
    echo "ping对端网路:fail"
    doSourceNetworkRoute
fi