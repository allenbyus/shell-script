iptables -A POSTROUTING -t nat -s 10.0.0.0/24 -j MASQUERADE -o eth0

// or
iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o venet0 -j MASQUERADE
