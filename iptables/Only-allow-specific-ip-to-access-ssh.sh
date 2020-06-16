iptables -A INPUT -s 192.168.3.7/32 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
