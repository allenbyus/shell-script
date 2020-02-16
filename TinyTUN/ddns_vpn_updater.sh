#!/bin/bash
doUpdate(){
	pkill tinytun
	VPN=`tinytun -k mypassword123 -c ${1}:10001`
	ifconfig $VPN 10.1.0.2 netmask 255.255.255.0
	iptables -A POSTROUTING -t nat -s 10.1.0.0/24 -j MASQUERADE -o eth0
	ip route add you_login_ip/32 via 156.96.105.1 dev eth0
	ip route add ${1}/32 via 156.96.105.1 dev eth0
	ip route del ${2}/32 via 156.96.105.1 dev eth0
	ip route del default
	ip route add default via 10.1.0.1 dev $VPN
	bash /etc/v/cidr-cn.sh
}
network_check=$(curl -s -w %{http_code} ip.sb)
if [ "${network_check}" = "000" ];then
	echo "网络连接：fail"
	pkill tinytun
	ip route del default
	ip route add default via you_local_gateway dev eth0
else
	echo "网络连接：OK"
fi
nslookupInfo=`nslookup hka.9.dnsabr.com | grep 'Address: '`
ddns_ip=`echo ${nslookupInfo#* }`
old_ip=`sed -n 1p ddnsip.txt`
echo "D${old_ip}D"
if [ "${old_ip}" = "${ddns_ip}" ];then
	echo "有效，IP：${ddns_ip}"
else
	echo "过期，新IP：${ddns_ip}"
	doUpdate "${ddns_ip}" "${old_ip}"
	echo $ddns_ip > ddnsip.txt
fi
