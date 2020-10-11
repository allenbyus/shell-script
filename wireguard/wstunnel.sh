#server
/usr/local/bin/wstunnel -q --server ws://0.0.0.0:11111 --restrictTo 127.0.0.1:10000
#client
/usr/local/bin/wstunnel -q --udp --udpTimeoutSec -1 -L 0.0.0.0:10606:127.0.0.1:10609 ws://192.168.1.111:11111
