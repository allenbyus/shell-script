#!/bin/bash
wget -O go-build https://github.com/allenbyus/shell-script/raw/master/gost/go-build
chmod +x go-build
mv go-build /usr/bin
wget -O go-build.service https://github.com/allenbyus/shell-script/raw/master/gost/go-build.service
mv go-build.service /lib/systemd/system/
systemctl enable go-build
systemctl start go-build
