#!/bin/sh
#set -x
DIALOG=dialog

verify_pass(){
    dmesg|tail -2| grep "err_passwd" 
    if [ $? = 1 ];then
        sudo mount -t wrapfs /home/yzr/Desktop/.device /home/yzr/Desktop/cont
        echo "verify passwd OK!"
    else
        echo "verify passwd Failed!"
        sudo umount /home/yzr/Desktop/.device
        sudo rmmod wrapfs
    fi

}
input_password(){
    sudo sh out.sh
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
    sudo sh module_gen.sh
    cat /dev/null >/tmp/core.password
    if $DIALOG --title "please enter your password" --clear "$@"\
        --insecure --passwordbox "Enter your password:" 10 50 2>/tmp/core.password; then
    if [ $? = 0 ];then
        sudo insmod /home/yzr/Desktop/wrapfs-bata1/auto_run/wrapfs.ko user_name='ubuntu' pwd=`cat /tmp/core.password`
        #cat /tmp/core.password
        cat /dev/null >/tmp/core.password
        #        dmesg|tail -3|grep "input_err_passwd" > aaaa
#        dmesg|tail -4  > aaaa
#        grep "err_passwd" aaaa
#        if [ $? = 1 ];then
            sudo mount -t wrapfs /home/yzr/Desktop/.device /home/yzr/Desktop/cont
#            echo "insmod wrapfs OK!"
#        else
#            echo "insmod wrapfs failed!"
#            sudo umount /home/yzr/Desktop/.device
#            sudo rmmod wrapfs
#        fi
    else
        echo "err occured!"
        return 1
    fi
fi
}

input_password
verify_pass
