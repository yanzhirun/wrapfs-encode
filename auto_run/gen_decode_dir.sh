#!/bin/bash

DIALOG=dialog
SRC_DIR_NAME="src_dir_name"
DEST_DIR_NAME="dest_dir_name"
#DIR_NAME=''
LOG_FILE="log"
declare user_name=""
auto_install_file="auto_run_wrapfs.sh"

print_log(){
    echo $1 | tee -a $LOG_FILE
}


print_shell(){
    echo $1 | tee -a $auto_install_file
}

set_src_dir(){
if $DIALOG --title "please input dir to be mounted by private decode filesystem" \
--inputbox "Pls input your dir:" 10 50 2>$SRC_DIR_NAME;then
DIR_NAME=`cat src_dir_name`

if [ ! -d $DIR_NAME ]; then
    return 1
else
    return 0
fi

fi
}

set_dest_dir(){
if $DIALOG --title "please input dir to be mounted for private decode filesystem" \
--inputbox "Pls input your dir:" 10 50 2>$DEST_DIR_NAME;then
dest_dir_name=`cat dest_dir_name`
if [ ! -d $dest_dir_name ]; then
    return 1
else
    return 0
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


gen_auto_run_shell(){
    print_shell "#!/bin/bash"
    print_shell "lsmod | grep wrapfs"
    print_shell "if [ \$? -eq 1 ]; then"
    print_shell "    echo \"not installed \""
    print_shell "    insmod wrapfs.ko user_name=\"$user_name\""
    print_shell "else"
    print_shell "    echo \"installed\""
    print_shell "fi"
    return 0
}

attach_auto_run_shell(){
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

#install_encode_fs
rm -rf $SRC_DIR_NAME
rm -rf $DEST_DIR_NAME
rm -rf $auto_install_file

get_user_name
gen_auto_run_shell

set_src_dir
while [ $? -eq 1 ]
do
    echo_wrong_msg
    set_src_dir
done
set_dest_dir
while [ $? -eq 1 ]
do
    echo_wrong_msg
    set_dest_dir
done

attach_auto_run_shell `cat $SRC_DIR_NAME` `cat $DEST_DIR_NAME`
chmod a+x $auto_install_file
#cp $auto_install_file /etc/init.d/
