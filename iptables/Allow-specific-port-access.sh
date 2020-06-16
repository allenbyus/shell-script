iptables -A INPUT  -p tcp --dport 80 -j ACCEPT
如果设置了FTP被动模式，就需要添加被动模式端口进行放行：
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 20000:30000 -j ACCEPT
规则写好后记得最后需要拒绝其他的请求，然后保存规则，不执行保存重启服务器后规则失效
/etc/init.d/iptables save
