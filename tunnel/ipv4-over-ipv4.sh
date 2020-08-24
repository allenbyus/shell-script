#Router A
ip tunnel add tunnel0 mode ipip remote 192.0.2.69 local 192.0.2.34
ip link set tunnel0 up
ip addr add 192.168.1.1/24 dev tunnel0
#Router B
ip tunnel add tunnel0 mode ipip remote 192.0.2.34 local 192.0.2.69
ip link set tunnel0 up
ip addr add 192.168.1.254/24 dev tunnel0
