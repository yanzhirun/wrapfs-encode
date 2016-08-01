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
		
#define MY_FILE "/home/seed/my_passwd"

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
		}else
		{
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
	mm_segment_t old_fs;
	
	file=filp_open(file_name, O_RDWR|O_APPEND|O_CREAT, 0644);
	if(IS_ERR(file))
	{
		printk("error occured while opening file %s, exiting...\n", MY_FILE);
		return 1;
	}
	old_fs = get_fs();
	set_fs(KERNEL_DS);

	file->f_op->write(file, (char *)user_name, strlen(user_name), &file->f_pos);
	file->f_op->write(file, INTERNAL_FLAG, strlen(INTERNAL_FLAG), &file->f_pos);
	file->f_op->write(file, (char *)passwd, strlen(passwd), &file->f_pos);
	file->f_op->write(file, BEGIN_FLAG, strlen(BEGIN_FLAG), &file->f_pos);
	set_fs(old_fs);
	
	filp_close(file, NULL);	
	return 0;
}

int wrapfs_get_key(char *file_name, char *user_name, char *passwd)
{
	struct file *file = NULL;
	int read_num;
	mm_segment_t old_fs;
	char buf[1024] = {0};
	
	file=filp_open(file_name, O_RDWR|O_APPEND, 0644);
	if(IS_ERR(file))
	{
		printk("error occured while opening file %s, exiting...\n", MY_FILE);
		goto fatal;
	}
	old_fs = get_fs();
	set_fs(KERNEL_DS);

	read_num = file->f_op->read(file, buf, sizeof(buf), &file->f_pos);
	if(read_num == 0)
	{
		printk("failed to find passwd\n");
		goto fatal;
	}else
	{
		if(wrapfs_parse_passwd(buf, read_num, user_name, passwd) == 1)
		{
			printk("parse passwd error\n");
			goto fatal;
		}
	}

	set_fs(old_fs);
	filp_close(file, NULL);	
	return 0;
fatal:
	set_fs(old_fs);
	filp_close(file, NULL);	
	return 1;
}

