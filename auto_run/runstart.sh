#!/bin/bash
lsmod | grep wrapfs 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "installed OK!"
else
	sudo insmod ~/Desktop/wrapfs-bata1/auto_run/wrapfs.ko user_name="ubuntu" pwd="123qqq"
	if [ $? -eq 0 ]; then
		echo "installed OK!"
	else
		echo "installed failed!"
	fi
fi
