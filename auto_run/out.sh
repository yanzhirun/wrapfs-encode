#!/bin/bash
lsmod | grep wrapfs
if [ $? -eq 0 ]; then
sudo umount $HOME/Desktop/.device
sudo rmmod wrapfs
if [ $? -eq 0 ]; then
    echo "rmmod OK!"
fi
else
echo "no wrapfs"
fi
rm /home/yzr/Desktop/wrapfs-bata1/auto_run/wrapfs.ko
ls
echo " ok!"
