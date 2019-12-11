df -h
vim /etc/fstab
#增加一行
tmpfs /run tmpfs nosuid,noexec,size=18M,nr_inodes=4096 0 0
