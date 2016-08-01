#!/bin/bash
`cp /usr/src/linux-headers-4.2.0-27-generic/Module.symvers /home/yzr/Desktop/wrapfs-bata1/wrapfs/`
make -C /usr/src/linux-4.2.5 M=/home/yzr/Desktop/wrapfs-bata1/wrapfs/ modules
`cp /home/yzr/Desktop/wrapfs-bata1/wrapfs/wrapfs.ko /home/yzr/Desktop/wrapfs-bata1/auto_run/`
lsmod | grep wrapfs
if [ $? -eq 1 ]; then
echo "not installed "
insmod ./wrapfs.ko user_name="yzr"
else
echo "installed"
fi
mount -t wrapfs /home/yzr/Desktop/device  /home/yzr/Desktop/cont
