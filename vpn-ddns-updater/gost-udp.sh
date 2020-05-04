#!/bin/bash
VPSNAME="HKT"
#echo "212 cmi" >> /etc/iproute2/rt_tables
ip route flush table cmi
ip route add default via 10.170.0.1 dev eth0 src 10.170.0.5 table cmi
ip rule add from 10.170.0.5 table cmi
doUpdate() {
	pkill go
	nohup go -L tun://:9222/${1}:10001?net=192.168.123.4/24 >/dev/null &
	sleep 3s
	ip route add ${1} via 10.170.0.1 dev eth0
	ip route del default
	ip route add default via 192.168.123.1
}
doSourceNetworkRoute() {
	pkill go
	ip route del default
	ip route add default via 10.170.0.1 dev eth0
	echo $ddns_ip > /etc/v/ddnsip.txt
}
doReport() {
	curl -d ${1} "https://tgpush.fjj.us/send?chatid=2*0****6&sign=*******"
}
network_check=$(curl --interface tun0 -s -w %{http_code} ip.sb)
if [[ "${network_check}" == "000" ]];then
    echo "网络连接：fail"
    doReport "${VPSNAME}: curl网络连接测试失败"
    doSourceNetworkRoute
else
    echo "网络连接：OK"
fi
nslookupInfo=`nslookup YOUR_SERVER_DDNS | grep 'Address: '`
ddns_ip=`echo ${nslookupInfo#* }`
old_ip=`sed -n 1p /etc/v/ddnsip.txt`
#server_avaliable_check_condition="Connection timed out"
#server_avaliable_check=$(nc -zvw3 ${ddns_ip} 11110 2>&1)
#if [[ ${server_avaliable_check} =~ ${server_avaliable_check_condition} ]]
#then
#    echo "服务端服务未开启！"
#    exit
#else
#    echo "服务端服务已开启！"
#fi
echo "记录中的地址：${old_ip}!"
if [ "${old_ip}" = "${ddns_ip}" ];then
    echo "有效，IP：${ddns_ip}"
else
    echo "过期，新IP：${ddns_ip}!"
    doReport "${VPSNAME}: IP${old_ip}过期，新IP：${ddns_ip}!"
    doUpdate "${ddns_ip}" "${old_ip}"
    echo $ddns_ip > /etc/v/ddnsip.txt
fi
if ping -c 1 192.168.123.1 &> /dev/null
then
    echo "ping对端网路:OK"
else
    echo "ping对端网路:fail"
    doReport "${VPSNAME}: ping对端网路测试失败"
    doSourceNetworkRoute
fi
