iptables -I FORWARD -i ztyqbub6jp -j ACCEPT
iptables -I FORWARD -o ztyqbub6jp -j ACCEPT
iptables -t nat -I POSTROUTING -o ztyqbub6jp -j MASQUERADE
