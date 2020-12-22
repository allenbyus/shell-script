#查看end数 ( count )
fdisk -u -l /dev/vda
#有压缩
dd bs=512 count=14680063 if=/dev/vda | gzip -6 > ghost.img
#无压缩
dd bs=512 count=14680063 if=/dev/vda of=ghost.img
