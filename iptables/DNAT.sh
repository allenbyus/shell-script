#DNAT目标地址转换：类似于端口映射
iptables -t nat -A PREROUTING -d 192.168.3.3 -p tcp --dport 80 -j DNAT --todestination 172.16.100.34
#把172.16.100.34服务器80端口的请求转发到服务器192.168.3.3 上
