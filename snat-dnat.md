## Some examples of SNAT, DNAT with iptables with comments
> mainly used in start-up script

### masquarade all outgoing packets to be WLAN0 IP
```sh
iptables -t nat -A PREROUTING -s 192.168.1.2 -i eth0 -j MASQUERADE
```

#### All packets leaving eth0 will have src eth0 ip address
```sh
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to 192.168.1.1
```

## Match rule specifying a source port
> Below makes sure packets from Eth Devices have correct source IP Address
> Notice, when specifying a port, protocol needs to be specified as well
```sh
iptables -t nat -A POSTROUTING -o wlan0 -s 192.168.1.2 -p udp --dport 16020 -j SNAT --to 10.1.1.7:51889
iptables -t nat -A POSTROUTING -o wlan0 -s 192.168.1.2 -p tcp --dport 21 -j SNAT --to 10.1.1.7:21
iptables -t nat -A POSTROUTING -o wlan0 -s 192.168.1.3 -j SNAT --to 10.1.1.9


# Packets destined for IP 10.1.1.7 will be forwaded to 192.168.1.2 UDP,TCP
# Packets destined for IP 10.1.1.9 will be forwaded to 192.168.1.3 UDP,TCP
# Does work with ping (ICMP) correctly
iptables -t nat -A PREROUTING -i wlan0 -d 10.1.1.7 -j DNAT --to-destination 192.168.1.2
iptables -t nat -A PREROUTING -i wlan0 -d 10.1.1.9 -j DNAT --to-destination 192.168.1.3
```

### Packets destined for IP 10.1.1.7 will be forwaded to 192.168.1.2 UDP,TCP
> Does NOT work with ping (ICMP) correctly, does not handle ICMP protocol
> WLAN IP reply on a ping without
```sh
iptables -t nat -A PREROUTING -p tcp -i wlan0 -d 10.1.1.7 -j DNAT --to-destination 192.168.1.2
iptables -t nat -A PREROUTING -p udp -i wlan0 -d 10.1.1.7 -j DNAT --to-destination 192.168.1.2
```

### Change SNMP port of outgoing SNMP messages
```sh
iptables -t nat -A OUTPUT -p udp --dport 162 -j DNAT --to-destination 192.168.1.33:1162
```

### Add secondary IP to WLAN0
```sh
ip addr add 10.1.1.7/24 dev wlan0
ip addr add 10.1.1.9/24 dev wlan0
```
### List all IP addresses asign to wlan0
```ip add list dev wlan0```

### All packets leaving eth1 will change source IP to 192.168.20.1
```sh
iptables -t nat -A POSTROUTING -o eth1 -j SNAT --to 192.168.20.1
```

### All TCP packets leaving eth1 on port 443 will change source IP to 192.168.20.1
```sh
iptables -t nat -A POSTROUTING -o eth1 -s 192.168.1.22 -p tcp --dport 443 -j SNAT --to 192.168.20.1:443
```

### All ICMP packets leaving eth1 will change source IP to 192.168.20.1
```sh
iptables -t nat -A POSTROUTING -o eth1 -s 192.168.1.22 -p icmp -j SNAT --to 192.168.20.1
```

### All supported packets leaving eth1 which have source IP 192.168.1.22 will change source IP to 192.168.20.1
```sh
iptables -t nat -A POSTROUTING -o eth1 -s 192.168.1.22 -p all -j SNAT --to 192.168.20.1
```

## SNAT on dynamically assign interface

> usage with WIFI dual mode where WiFi can be AP and STA at the same time
> add to **start-up script**
```sh
# assuming wlan1 is STA interface
ip=$(ip -o addr show up primary scope global wlan1 |
      while read -r num dev fam addr rest; do echo ${addr%/*}; done)
echo $ip

# all packets leaving wlan1 will change source IP to STA interface IP
iptables -t nat -A POSTROUTING -o wlan1 -j SNAT --to $ip
```

## Check NAT table

```sh
iptables -t nat -L -n -v
```
