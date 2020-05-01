服务端：
socat -u open:FILENAME tcp-listen:12345
客户端:
socat -u tcp:ServerIP:12345 open:LOCALFILE,create
