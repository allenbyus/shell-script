#echo "212 cmi" >> /etc/iproute2/rt_tables
ip route flush table cmi
ip route add default via 156.96.153.1 dev eth0 src 156.96.153.55 table cmi
ip rule add from 156.96.153.55 table cmi
