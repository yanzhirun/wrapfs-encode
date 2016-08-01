#ifndef _CRYPTO_H_
#define _CRYPTO_H_


#define ENCODE_SUCCESSED 1
#define DECODE_SUCCESSED 0
#define SRC_FILE_OPEN_FAILED -1
#define DEST_FILE_CREATE_FAILED -2
#define ERROR_ENCODE_FILE -3
#define ENCODE_FILE_TAG "E"
#define ENCODE_FILE_TAG_LEN 1
#define BUFF 1024


void wrapfs_blowfish_init(const char *key, const int nlength);
int blowfish_encode_mem(const unsigned char *pSrc, unsigned char *pDest, unsigned int size);
int blowfish_decode_mem(const unsigned char *pSrc, unsigned char *pDest, unsigned int size);


void wrapfs_blowfish_encode(unsigned char *pSrc, unsigned char *pDest);
void wrapfs_blowfish_decode(unsigned char *pSrc, unsigned char *pDest);
#endif //_BLOWTEST_H_
