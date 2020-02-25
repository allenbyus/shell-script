#!/bin/bash
doAddChinaRoute(){
    for line in `cat /root/cidr-cn.txt`
    do
        ip route add $line via 10.170.0.1 dev eth0
    done
}
doUpdate(){
    pkill tinytun
    VPN=`tinytun -k mypassword123 -c ${1}:10001 -d 'tap0'`
    ifconfig $VPN 10.1.0.3 netmask 255.255.255.0
    iptables -A POSTROUTING -t nat -s 10.1.0.0/24 -j MASQUERADE -o eth0
    ip route add 59.120.227.144/32 via 10.170.0.1 dev eth0
    ip route add ${1} via 10.170.0.1 dev eth0
    ip route add 169.254.169.254 via 10.170.0.1 dev eth0 #额外路由(dns)
    ip route del ${2} via 10.170.0.1 dev eth0
    ip route del default
    ip route add default via 10.1.0.1 dev $VPN
    doAddChinaRoute
}
doSourceNetworkRoute(){
    pkill tinytun
    ip route del default
    ip route add default via 10.170.0.1 dev eth0
    echo 1.1.1.1>ddnsip.txt
    echo "已恢复源网路路由"
}
network_check=$(curl --interface tap0 -s -w %{http_code} ip.sb)
if [[ "${network_check}" == "000" ]];then
    echo "网络连接：fail"
    doSourceNetworkRoute
else
    echo "网络连接：OK"
fi
nslookupInfo=`nslookup hka.9.dnsabr.com | grep 'Address: '`
ddns_ip=`echo ${nslookupInfo#* }`
old_ip=`sed -n 1p ddnsip.txt`
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
    echo "过期，新IP：${ddns_ip}"
    doUpdate "${ddns_ip}" "${old_ip}"
    echo $ddns_ip > ddnsip.txt
fi
if ping -c 1 10.1.0.1 &> /dev/null
then
    echo "ping对端网路:OK"
else
    echo "ping对端网路:fail"
    doSourceNetworkRoute
fi
