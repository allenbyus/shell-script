#server_avaliable_check=$(nc -zvw3 1.1.1.1 80 1> /dev/stdout)
#server_avaliable_check=$(nc -zvw3 1.1.1.1 80 2> /dev/stdout)
server_avaliable_check=$(nc -zvw3 1.1.1.1 80 2>&1)
echo $server_avaliable_check
