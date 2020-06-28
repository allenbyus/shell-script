iptables -t nat -A PREROUTING -i eth1 -p udp --dport 53 -j DNAT --to 192.168.6.10
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 53 -j DNAT --to 192.168.6.10
