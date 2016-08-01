#ifndef CRYPTO_HASH_H_
#define CRYPTO_HASH_H_

#define HEADER_SHA512 "SHA512"


#define BEGIN_FLAG "#"
#define INTERNAL_FLAG "|"


#define __in
#define __inout

typedef enum _chasherr_t {
	HASH_ERR_NONE = 0,
	HASH_ERR_INVALID_ARG,
	HASH_ERR_ALLOC,
} chasherr_t;

#define HASH_ERR_MAX HASH_ERR_ALLOC
#define HASH_SUCCESS(_ERR_) ((_ERR_) == HASH_ERR_NONE)
#define HASH_FAILURE(_ERR_) (!HASH_SUCCESS(_ERR_))

#define FILE_PWD_STORE "/home/yzr/passwd_store" 
#define FILE_NAME 30
#define FILE_RANDOM 16

typedef struct _key_store{
        __in char file_name[FILE_NAME];
        __in char random_number[FILE_RANDOM];
        //__in unsigned random_number;
        //__inout cryptop_digest_sha512 *digest;
	__in int status; 
}key_store_point;


#define CRYPTO_DIGEST_SHA512_LEN 0x48
typedef struct _cryptop_digest_sha512 {
	uint8_t data[CRYPTO_DIGEST_SHA512_LEN];
} cryptop_digest_sha512;
	
static chasherr_t crypto_hash_sha512(
	__in const uint8_t *data,
	__in size_t length,
	__inout cryptop_digest_sha512 *digest
	);

//const char *crypto_hash_version(void);
void get_random_bytes(void *buf, int nbytes);

//static int random_number(int min, int max);
int wrapfs_get_encode_pwd(const char* file_name, const char* random, char *pwd, int length);

void print_digest(__in const char *header,__in const char *input,__in const void *digest,__in size_t length);

#endif // CRYPTO_HASH_H_
