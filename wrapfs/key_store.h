#ifndef __KEY_STORE_H_
#define __KEY_STORE_H_


int wrapfs_key_store(char *file_name, char *user_name, char *passwd);
int wrapfs_get_key(char *file_name, char *user_name, char *passwd);



#endif //__KEY_STORE_H_
