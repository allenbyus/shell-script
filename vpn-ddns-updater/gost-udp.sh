#!/bin/bash
LOG=""
VPSNAME="HK"
VPSINTERFACE="eth0"
VPSIP="12.2.2.2"
VPSGATEWAY="12.2.2.1"
VPSVPNIP="192.12.12.2"
VPSVPNGATEWAY="192.12.12.1"
VPN_SERVER_DDNS="ddns.vpn.server"
REPORT_API_URL="https://report_api_url/?send?auth=****"
#echo "212 cmi" >> /etc/iproute2/rt_tables
ip route flush table cmi
ip route add default via ${VPSGATEWAY} dev ${VPSINTERFACE} src ${VPSIP} table cmi
ip rule add from ${VPSIP} table cmi
doKillProcess() {
    pid=$(ps -ef | grep 'go -L tun://:9222/' | grep -v grep | awk '{print $2}')
    if [[ "${pid}" == "" ]];then
        echo "first boot success."
    else
        kill ${pid}
        LOG+="${VPSNAME}: kill process success."
        doReport
    fi
}
doUpdate() {
    doKillProcess
    nohup go -L tun://:9222/${1}:10001?net=${VPSVPNIP}/24&name=tun0 >/dev/null &
    sleep 3s
    ip route add ${1} via ${VPSGATEWAY} dev ${VPSINTERFACE}
    ip route del default
    ip route add default via ${VPSVPNGATEWAY}
}
doSourceNetworkRoute() {
    doKillProcess
    ip route del default
    ip route add default via ${VPSGATEWAY} dev ${VPSINTERFACE}
    echo $ddns_ip > /etc/v/ddnsip.txt
}
doReport() {
    curl -d "${LOG}" "${REPORT_API_URL}"
    LOG=""
}
network_check=$(curl --interface tun0 -s -w %{http_code} ip.sb)
if [[ "${network_check}" == "000" ]];then
    echo "Internet connection:fail"
    LOG+="${VPSNAME}: curl network connection test failed"
    doReport
    doSourceNetworkRoute
else
    echo "Internet connection: OK"
fi
nslookupInfo=`nslookup ${VPN_SERVER_DDNS} | grep 'Address: '`
ddns_ip=`echo ${nslookupInfo#* }`
old_ip=`sed -n 1p /etc/v/ddnsip.txt`
#server_avaliable_check_condition="Connection timed out"
#server_avaliable_check=$(nc -zvw3 ${ddns_ip} 11110 2>&1)
#if [[ ${server_avaliable_check} =~ ${server_avaliable_check_condition} ]]
#then
#    echo "The server service is not enabled!"
#    exit
#else
#    echo "The server service has been started!"
#fi
echo "Address in record:${old_ip}!"
if [ "${old_ip}" = "${ddns_ip}" ];then
    echo "Effective, IP:${ddns_ip}"
else
    echo "Expired, new IP:${ddns_ip}!"
    LOG+="${VPSNAME}: IP${old_ip} Expired, new IP: ${ddns_ip}!"
    doReport
    doUpdate "${ddns_ip}" "${old_ip}"
    echo $ddns_ip > /etc/v/ddnsip.txt
fi
if ping -c 1 ${VPSVPNGATEWAY} &> /dev/null
then
    echo "Ping the peer network: OK"
else
    echo "Ping the peer network: fail"
    LOG+="${VPSNAME}: Ping the peer network: fail"
    doReport
    doSourceNetworkRoute
fi
