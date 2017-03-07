#!/bin/bash
RUN_START="runstart.sh"
WRAPFS_INSTALL="~/Desktop/wrapfs-bata1/auto_run"
declare NAME="ubuntu"
PWD=$(cat ~/passwordsave)
#PWD="`cat ~/passwordsave`"
print_shell(){
#    echo $1 | tee -a $RUN_START
    echo -e $1 1>>$RUN_START
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

gen_auto_run
chmod a+x $RUN_START
