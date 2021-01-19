#查看end数 ( count )
fdisk -u -l /dev/vda
#有压缩
dd bs=512 count=14680063 if=/dev/vda | gzip -6 > ghost.img.gz
#还原
gzip -dc ghost.img.gz | dd of=/dev/vda
#无压缩
dd bs=512 count=14680063 if=/dev/vda of=ghost.img
#还原
dd if=ghost.img of=/dev/vda
