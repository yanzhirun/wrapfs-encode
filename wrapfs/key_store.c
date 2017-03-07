#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/syscalls.h>
#include <asm/unistd.h>

#define BEGIN_FLAG "#"
#define INTERNAL_FLAG "|"
#define PASSWD_LEN 6

#define READ_LEN 16
#define WRITE_LEN 16

#define MY_FILE "/etc/.passwordsave"

static int wrapfs_parse_passwd(char *buf, int size, char *user_name, char *passwd)
{
	char *result = NULL;
	char *cur_name = NULL;
	//printk("weixun wrapfs parse input buf: %s\n", buf);
	result = strsep(&buf, BEGIN_FLAG);
	while(result != NULL)
	{
		//printk("weixun wrapfs parse passwd: %s\n", result);
		if(strncmp(result, " ", 1) == 0)
		{
			break;
		}else{
			cur_name = strsep(&result, INTERNAL_FLAG);
			if(strncmp(cur_name, user_name, strlen(user_name)) == 0)
			{
				strncpy(passwd, result, PASSWD_LEN);
				break;
			}
		}
		result = strsep(&buf, BEGIN_FLAG);

	}


	return 0;
}


int wrapfs_key_store(char *file_name, char *user_name, char *passwd)
{
	struct file *file = NULL;

    printk(KERN_ALERT"wrapfs_keystore:%s", passwd);
	mm_segment_t old_fs;
    loff_t pos = 0;
    int err = 0;

	file = filp_open(MY_FILE, O_RDWR|O_CREAT, 0644);
	if(IS_ERR(file))
	{
		printk("error occured while opening file %s in key_store, exiting...\n", MY_FILE);
		return 1;
    }

	old_fs = get_fs();
	set_fs(KERNEL_DS);
    vfs_write(file, passwd, WRITE_LEN, &pos);

//    vfs_write(file, user_name, strlen(user_name), &file->f_pos);
//	file->f_op->write(file, (char *)user_name, strlen(user_name), &file->f_pos);
//	file->f_op->write(file, INTERNAL_FLAG, strlen(INTERNAL_FLAG), &file->f_pos);
//	file->f_op->write(file, (char *)passwd, strlen(passwd), &file->f_pos);
//	file->f_op->write(file, BEGIN_FLAG, strlen(BEGIN_FLAG), &file->f_pos);

    filp_close(file, NULL);
    set_fs(old_fs);
    return 0;
}

int wrapfs_get_key(char *file_name, char *user_name, char *passwd)
{
	struct file *file = NULL;
//	int read_num;
	mm_segment_t old_fs;
//	char buf[64] = {0};
    int err = 0;
    loff_t pos = 0;

    //printk(KERN_ALERT"wrapfs_get_key");
	file = filp_open(MY_FILE, O_RDONLY|O_CREAT, 0644);

	if(IS_ERR(file))
	{
		printk("error occured while opening file %s in get_key, exiting...\n", MY_FILE);
		goto fatal;
	}
	old_fs = get_fs();
	set_fs(KERNEL_DS);
    //char read_file[16] = {0};

    err = vfs_read(file, passwd, READ_LEN, &pos);
    //err = vfs_read(file, read_file, READ_LEN, &pos);
    //printk(KERN_ALERT " passwd: %s", read_file);
//	read_num = file->f_op->read(file, buf, sizeof(buf), &file->f_pos);
//	if(read_num == 0)
//	{
//		printk("failed to find passwd\n");
//		goto fatal;
//	}else
//	{
//		if(wrapfs_parse_passwd(buf, read_num, user_name, passwd) == 1)
//		{
//			printk("parse passwd error\n");
//			goto fatal;
//		}
//	}
    //passwd =read_file;
	set_fs(old_fs);
	filp_close(file, NULL);
	return 0;
fatal:
	set_fs(old_fs);
	filp_close(file, NULL);
	return 1;
}
