#!/bin/bash
REMOTE_SERVER_ADDRESS="hka.9.dnsabr.com"
REMOTE_SERVER_PORT="10001"
REMOTE_GATEWAY_IP="10.1.0.1"
LOCAL_IP="10.1.0.3"
LOCAL_GATEWAY_IP="10.170.0.1"
LOCAL_GATEWAY_DEV="eth0"
doAddChinaRoute(){
    for line in `cat /root/cidr-cn.txt`
    do
        ip route add $line via ${LOCAL_GATEWAY_IP} dev ${LOCAL_GATEWAY_DEV}
    done
}
doDelChinaRoute(){
    for line in `cat /root/cidr-cn.txt`
    do
        ip route del $line via ${LOCAL_GATEWAY_IP} dev ${LOCAL_GATEWAY_DEV}
    done
}
doUpdate(){
    pkill tinytun
    VPN=`tinytun -k mypassword123 -c ${1}:${REMOTE_SERVER_PORT} -d 'tap0'`
    ifconfig $VPN ${LOCAL_IP} netmask 255.255.255.0
    iptables -A POSTROUTING -t nat -s 10.1.0.0/24 -j MASQUERADE -o ${LOCAL_GATEWAY_DEV}
    ip route add 59.120.227.144/32 via ${LOCAL_GATEWAY_IP} dev ${LOCAL_GATEWAY_DEV}
    ip route add ${1} via ${LOCAL_GATEWAY_IP} dev ${LOCAL_GATEWAY_DEV}
    ip route del ${2} via ${LOCAL_GATEWAY_IP} dev ${LOCAL_GATEWAY_DEV}
    ip route del default
    ip route add default via ${REMOTE_GATEWAY_IP} dev $VPN
    doAddChinaRoute
}
doSourceNetworkRoute(){
    pkill tinytun
    ip route del default
    ip route add default via ${LOCAL_GATEWAY_IP} dev ${LOCAL_GATEWAY_DEV}
    echo 1.1.1.1>ddnsip.txt
    doDelChinaRoute
    echo "已恢复源网路路由"
}
network_check=$(curl --interface tap0 -s -w %{http_code} ip.sb)
if [[ "${network_check}" == "000" ]];then
    echo "网络连接：fail"
    doSourceNetworkRoute
else
    echo "网络连接：OK"
fi
nslookupInfo=`nslookup ${REMOTE_SERVER_ADDRESS} | grep 'Address: '`
ddns_ip=`echo ${nslookupInfo#* }`
old_ip=`sed -n 1p ddnsip.txt`
server_avaliable_check_condition="Connection timed out"
server_avaliable_check=$(nc -zvw3 ${ddns_ip} ${REMOTE_SERVER_PORT} 2>&1)
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
if ping -c 1 ${REMOTE_GATEWAY_IP} &> /dev/null
then
    echo "ping对端网路:OK"
else
    echo "ping对端网路:fail"
    doSourceNetworkRoute
fi
