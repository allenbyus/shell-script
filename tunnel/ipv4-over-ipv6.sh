ip link add name ipip6 type ip6tnl local 2a00:b700::22e remote 2a02:180:6:1::1a6b mode any dev eth0
ip link set dev ipip6 up
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
ip addr add 10.0.0.2/32 dev ipip6
ip route add 10.0.0.0/24 dev ipip6

ip link add name ipip6 type ip6tnl local 2a02:180:6:1::1a6b remote 2a00:b700::22e mode any dev eth0
ip link set dev ipip6 up
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
ip addr add 10.0.0.1/32 dev ipip6
ip route add 10.0.0.0/24 dev ipip6

now, you can ping 10.0.0.1 or 10.0.0.2
