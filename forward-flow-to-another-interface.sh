iptables -I FORWARD -o br-lan -j ACCEPT
iptables -I FORWARD -o tap0 -j ACCEPT
iptables -t nat -I POSTROUTING -o tap0 -j MASQUERADE
