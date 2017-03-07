#!/bin/sh
#set -x
DIALOG=dialog

input_password(){
    mount |grep wrapfs 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "mount OK!"
        return 0;
    else
        lsmod | grep wrapfs 1>/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "wrapfs has already insmod!"
            return 0;
        fi
    fi
    cat /dev/null >/tmp/core.password
    if $DIALOG --title "please enter your password" --clear "$@"\
        --insecure --passwordbox "Enter your password:" 10 50 2>/tmp/core.password; then
    if [ $? = 0 ];then
        sudo insmod /home/yzr/Desktop/wrapfs-bata1/auto_run/wrapfs.ko user_name='ubuntu' pwd=`cat /tmp/core.password`
        #cat /tmp/core.password
        cat /dev/null >/tmp/core.password

        dmesg | tail -5 | grep "input err passwd"
        if [ $? = 1 ];then
            if [ $? -eq 0 ]; then
                sudo mount -t wrapfs /home/yzr/Desktop/.device /home/yzr/Desktop/cont
                if [ $? -eq 0 ]; then
                    echo "insmod wrapfs OK!"
                fi
            else
                echo "insmod wrapfs failed!"
            fi
        else
            sudo umount /home/yzr/Desktop/.device
            sudo rmmod wrapfs
        fi
    else
        echo "err occured!"
        return 1
    fi
fi
}

input_password

