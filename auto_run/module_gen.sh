#!/bin/bash
if  lsmod | grep wrapfs &>/dev/null ; then
    echo "There is already insmod wrapfs module!"
    `sudo rmmod wrapfs`
fi
sudo cp /usr/src/linux-headers-4.2.0-27-generic/Module.symvers $HOME/Desktop/wrapfs-bata1/wrapfs/
sudo make -C /usr/src/linux-4.2.5 M=$HOME/Desktop/wrapfs-bata1/wrapfs/ modules
sudo cp $HOME/Desktop/wrapfs-bata1/wrapfs/wrapfs.ko $HOME/Desktop/wrapfs-bata1/auto_run/
#sudo insmod $HOME/Desktop/wrapfs-bata1/auto_run/wrapfs.ko user_name="$USER" pwd='aaa!@#123'
#if  lsmod | grep wrapfs &>/dev/null ; then
#    echo "insmod wrapfs OK!"
#else
#    echo "insmod wrapfs err!"
#fi
