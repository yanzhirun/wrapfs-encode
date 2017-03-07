#!/bin/bash
DIALOG=dialog
SRC_DIR_NAME="src_dir_name"
DEVICE_DIR_NAME="device_dir_name"
PASSWORDSAVE="$HOME/passwordsave"
#DIR_NAME=''
LOG_FILE="log"
#declare user_name=""
auto_install_file="auto_run_wrapfs.sh"

start_info(){

$DIALOG --title "MESSAGE BOX" --clear "$@" \
        --msgbox "欢迎使用wrapfs透明加密文件系统. 请务必认真阅读和理解本《软件许可使用协议》（以下简称《协议》）中规定的所有权利和限制。您一旦安装、复制、下载、访问或以其它方式使用本软件产品，将视为对本《协议》的接受，即表示您同意接受本《协议》各项条款的约束。如果您不同意本《协议》中的条款，请不要安装、复制或使用本软件。
1 修改和终止服务
我们始终在不断更改和改进我们的服务。我们可能会增加或删除功能，也可能暂停或彻底停止某项服务。
您可以随时停止使用我们的服务，尽管我们对此表示非常遗憾。我们也可能随时停止向您提供服务，或随时对我们的服务增加或设置新的限制。
2 保证和免责声明
我们在提供服务时将会尽到商业上合理水平的技能和注意义务，希望您会喜欢使用它们。但有些关于服务的事项恕我们无法作出承诺。
除本条款或附加条款中明确规定的内容外，本公司对软件提供的各项服务均不作任何具体承诺。例如，我们对服务中的内容、服务的具体功能，或其可靠性、可用性或满足您需要的能力不作任何承诺。服务是“按原样”提供的。
3 服务的责任
在法律允许的范围内，本公司不承担利润损失、收入损失或数据、财务损失或间接、特殊、后果性、惩戒性或惩罚性损害赔偿责任。
" 30 50
}

print_log(){
    echo $1 | tee -a $LOG_FILE
}


print_shell(){
    echo $1 | tee -a $auto_install_file
}

gen_module(){
    sudo rmmod wrapfs
    sudo cp /usr/src/linux-headers-4.2.0-27-generic/Module.symvers $HOME/Desktop/wrapfs-bata1/wrapfs/
    lsmod |grep wrapfs 1>/dev/null 2>&1
    if [ $? -eq 1 ]; then
        sudo make -C /usr/src/linux-4.2.5 M=$HOME/Desktop/wrapfs-bata1/wrapfs/ modules
        if [ $? -eq 1 ]; then
            echo "make modules err!"
        else
            sudo cp $HOME/Desktop/wrapfs-bata1/wrapfs/wrapfs.ko $HOME/Desktop/wrapfs-bata1/auto_run/
        fi
    else
        sudo insmod $HOME/Desktop/wrapfs-bata1/auto_run/wrapfs.ko user_name='ubuntu' pwd=`cat $PASSWORDSAVE`
        if [ $? -eq 1 ]; then
            echo "you need restart the config"
    fi
}

print_OK(){
    $DIALOG --title "Wrapfs encrypt config" --clear "$@" \
            --msgbox "Hi, User. You have config all the info.The box will remain until you priss the ENTER key." 10 30
}

select_cont_path(){
    exec 3>&1
    if $DIALOG --title "Please choose a file for private decode filesystem" "$@" --fselect $HOME/Desktop/cont/ 16 48 2>$SRC_DIR_NAME ; then
    DIR_NAME=`cat src_dir_name`
    if [ ! -d $DIR_NAME ]; then
        return 1
    else
        return 0
    fi
fi
}

set_src_dir(){
    if $DIALOG --title "please input dir to be mounted by private decode filesystem" \
        --inputbox "Pls input your dir--for use: (default:/home/yzr/Desktop/cont)" \
        10 50 $HOME/Desktop/cont 2>$SRC_DIR_NAME;then
    DIR_NAME=`cat src_dir_name`

    if [ ! -d $DIR_NAME ]; then
        return 1
    else
        return 0
    fi

fi
}

set_device_dir(){
    if $DIALOG --title "Please choose a file for private decode filesystem()" "$@" --fselect $HOME/Desktop/.device/ 16 48 2>$DEVICE_DIR_NAME ; then
#    if $DIALOG --title "please input dir to be mounted for private decode filesystem" \
#        --inputbox "Pls input your dir: (default:/home/yzr/Desktop/.device)" \
#        10 50 /home/yzr/Desktop/.device  2>$DEVICE_DIR_NAME;then
    echo $DEVICE_DIR_NAME
    device_dir_name=`cat device_dir_name`
    if [ ! -d $device_dir_name ]; then
        return 1
    else
        return 0
    fi

fi
}

set_password(){
    if $DIALOG --title "please enter your password" --clear "$@"\
        --insecure --passwordbox "Enter your password:" 10 50 2>$PASSWORDSAVE;then
    exitstatus=$?
    if [ $exitstatus = 0 ];then
        print_OK
        return 0
    else
        return 1
    fi
fi
}

install_encode_fs(){
    result=`echo "insmod ./wrapfs.ko" | tee -a $LOG_FILE`
    if [ $result -eq 0 ];then
        echo "insmod wrapfs.ko successful" | tee -a $LOG_FILE
        return 0
    else
        echo "insmod wrapfs.ko error" | tee -a $LOG_FILE
        return 1
    fi

}

echo_wrong_msg(){
    $DIALOG --title WRONG_DIR --msgbox "You have input wrong dir, pls re-input!" 10 40
    return 0
}

echo_wrong_password(){
    $DIALOG --title WRONG_PASSWORD --msgbox "You need a strong password, pls re-input!" 10 40
    return 0
}

gen_auto_run_shell_old(){
    print_shell "#!/bin/bash"
    print_shell "lsmod | grep wrapfs"
    print_shell "if [ \$? -eq 1 ]; then"
    print_shell "    echo \"not installed \""
    print_shell "    insmod wrapfs.ko user_name=\"$user_name\" pwd=\"$PWD\""
#print_shell "    insmod wrapfs.ko user_name=\"$user_name\""
    print_shell "else"
    print_shell "    echo \"installed\""
    print_shell "fi"
    return 0
}

attach_auto_run_shell(){
    print_shell "umount $1"
    print_shell "mount -t wrapfs $1 $2"
    return 0
}

get_user_name(){
    var=`ls -author gen_decode_dir.sh`
    num=0
    for element in $var
    do
        if [ $num -eq 2 ];then
            user_name=$element
        fi
        let num+=1
    done

}

gen_auto_run(){
    print_shell "#!/bin/bash"
    print_shell "lsmod | grep wrapfs 1>/dev/null 2>&1"
    print_shell "if [ \$? -eq 0 ]; then"
    print_shell "\techo \"installed OK!\""
    print_shell "else"
    print_shell "\tsudo insmod $WRAPFS_INSTALL/wrapfs.ko user_name=\"$NAME\" pwd=\"$PWD\""
    print_shell "\tif [ \$? -eq 0 ]; then"
    print_shell "\t\techo \"installed OK!\""
    print_shell "\telse"
    print_shell "\t\techo \"installed failed!\""
    print_shell "\tfi"
    print_shell "fi"
}
#install_encode_fs
rm -rf $SRC_DIR_NAME
rm -rf $DEVICE_DIR_NAME
rm -rf $auto_install_file

get_user_name
gen_auto_run_shell

start_info
select_cont_path
while [ $? -eq 1 ]
do
    echo_wrong_msg
    set_src_dir
done
#set_src_dir
#while [ $? -eq 1 ]
#do
#    echo_wrong_msg
#    set_src_dir
#done
set_device_dir
while [ $? -eq 1 ]
do
    echo_wrong_msg
    set_device_dir
done
set_password
while [ $? -eq 1 ]
do
    echo_wrong_password
    set_password
done
gen_module

#attach_auto_run_shell `cat $DEVICE_DIR_NAME` `cat $SRC_DIR_NAME` 
chmod a+x $auto_install_file
sudo sh $auto_install_file
#cp $auto_install_file /etc/init.d/
