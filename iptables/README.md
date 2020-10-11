```
iptables定义规则:格式：iptables [-t table] COMMAND chain CRETIRIA -j ACTION
iptables [-t表名]  <链名> <动作>
-t table ：指定设置的表：filter nat mangle  不指定默认为filter
COMMAND：定义如何对规则进行管理
chain：指定你接下来的规则到底是在哪个链上操作的，当定义策略的时候，可以省略
CRETIRIA:指定匹配标准
-j ACTION :指定如何进行处理
COMMAND详解：
-P :设置默认策略（设定默认门是关着的还是开着的）   
     iptables -P INPUT DROP 这就把默认规则给拒绝了
-F: FLASH，清空规则链     
     iptables -t nat -F PREROUTING 
     iptables -t nat -F 清空nat表的所有规则
-Z：清空链   iptables -Z :清空
 
-A：追加，在当前链的最后新增一个规则
-I num : 插入，把当前规则插入为第几条  
     -I 3
-R num：Replays替换/修改第几条规则   
     iptables -R 3 …………
-D num：删除，明确指定删除第几条规则   
     iptables -D INPUT 12
 
-L 查看规则，下面包含子命令：
     -n：以数字的方式显示ip，它会将ip直接显示出来，如果不加-n，则会将ip反向解析成主机名。
     -v：显示详细信息
     --line-numbers : 显示规则的行号
CRETIRIA 详解：
1.通用匹配：源地址目标地址的匹配
     -s：指定作为源地址匹配，这里不能指定主机名称，必须是IP，地址可以取反，加一个“!”表示除了哪个IP之外
     -d：表示匹配目标地址
     -p：用于匹配协议的（这里的协议通常有3种，TCP/UDP/ICMP）
     -i eth0：从这块网卡流入的数据   （流入一般用在INPUT和PREROUTING上）
     -o eth0：从这块网卡流出的数据  （流出一般在OUTPUT和POSTROUTING上）
2.扩展匹配（隐含扩展：对协议的扩展 和显式扩展（-m））
     -p tcp :TCP协议的扩展
       --dport XX-XX：指定目标端口,不能指定多个非连续端口,只能指定单个端口
       --sport：指定源端口
       --tcp-fiags：TCP的标志位匹配（SYN,ACK，FIN,PSH，RST,URG）（使用相对较少）
       --tcpflags syn,ack,fin,rst syn  用于检测三次握手的第一次包，可简写为--syn
     -p udp：UDP协议的扩展  （与tcp相似）
     -p icmp：icmp数据报文的扩展
     -m multiport：表示启用多端口扩展  --dports 21,23,80
-j ACTION 详解：
     DROP：表示丢弃
     REJECT：明示拒绝
     ACCEPT：接受
     custom_chain：转向一个自定义的链
     MASQUERADE：源地址伪装
     REDIRECT：重定向：主要用于实现端口重定向
     RETURN：返回：在自定义链执行完毕后使用返回，来返回原规则链
```
```
查看规则:

iptables -L 列出默认表 filter 所有链上的规则。
iptables -t nat -L 列出 nat 表中所有链上的规则
iptables -t nat -L PREROUTING 列出 nat 表中 PREROUTING 链上的规则
拦截特定流量:

iptables -t filter -A INPUT -s 11.11.11.11 -j DROP 拦截来自特定 IP 地址(11.11.11.11)对本地服务全部流量
iptables -t filter -D INPUT -s 11.11.11.11 -j DROP 删除上一条拦截规则
iptables -t filter -A INPUT -p tcp -sport 445 -j DROP 封锁特定端口(TCP 445)
iptables -t filter -A INPUT -p icmp --icmp-type echo-request -j REJECT ---reject-with icmp-host-prohibited 禁止 ICMP (ping)
iptables -t filter -A OUTPUT -p tcp --dport 80 -m state --state NEW -j DROP 禁止从80端口发起新的TCP连接但允许80端口响应TCP连接
作为网关提供NAT服务:

iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -j SNAT --to-source 192.168.1.1 将来自192.168.2.0/24子网数据包源地址改写为192.168.1.1
iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -j MASQUERADE 将来自192.168.2.0/24子网数据包源地址改写为防火墙地址
iptables -t nat -A PREROUTING -d 192.168.1.1/24 --dport 80 -j DNAT --to-destination 192.168.1.11:80 将对192.168.1.1:80的数据包发送到192.168.1.11:80
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080将对本地80端口的数据包重定向到8080
```
