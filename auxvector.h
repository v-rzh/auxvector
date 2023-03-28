#ifndef AUXVECTOR_H
#define AUXVECTOR_H

#define AT_PHDR     3
#define AT_PHENT    4
#define AT_PHNUM    5
#define AT_PAGESZ   6
#define AT_BASE     7
#define AT_FLAGS    8
#define AT_ENTRY    9
#define AT_UID      11
#define AT_EUID     12
#define AT_GID      13
#define AT_EGID     14
#define AT_CLKTCK   17
#define AT_HWCAP    16
#define AT_SECURE   23


#define AUX_VECTOR_ORDER            \
    X(AT_HWCAP, AT_HWCAP_ORD)       \
    X(AT_PAGESZ, AT_PAGESZ_ORD)     \
    X(AT_CLKTCK, AT_CLKTCK_ORD)     \
    X(AT_PHDR, AT_PHDR_ORD)         \
    X(AT_PHENT, AT_PHENT_ORD)       \
    X(AT_PHNUM, AT_PHNUM_ORD)       \
    X(AT_BASE, AT_BASE_ORD)         \
    X(AT_FLAGS, AT_FLAGS_ORD)       \
    X(AT_ENTRY, AT_ENTRY_ORD)       \
    X(AT_UID, AT_UID_ORD)           \
    X(AT_EUID, AT_EUID_ORD)         \
    X(AT_GID, AT_GID_ORD)           \
    X(AT_EGID, AT_EGID_ORD)         \
    X(AT_SECURE, AT_SECURE_ORD)     \
    X(0, AUXVLEN)

#define SCAN_VECTOR_SIZE  (AUXVLEN*sizeof(unsigned long int))

struct aux_entry {
    unsigned long int id;
    unsigned long int val;
};

enum aux_order_enum {
#define X(a,b) b,
    AUX_VECTOR_ORDER
#undef X
};

struct aux_entry *get_beg_auxvector(unsigned long int st_addr_int, unsigned long int max_addr);
#endif
