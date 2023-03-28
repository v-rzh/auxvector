#include "auxvector.h"

#if __WORDSIZE == 64
#define STACK_UPPER_BOUND   0x7ffffffff000
#else
#define STACK_UPPER_BOUND   0xffffffff
#endif

#define __exit_nr 1

void __exit(unsigned long status)
{
    __asm__ volatile (
    "mov %0, %%eax\n\t"
    "mov %1, %%ebx\n\t"
    "int 0x80\n\t"
    : : "g" (__exit_nr), "g" (status)
    );
}

void _start(void)
{
    char c;
    struct aux_entry *aux = get_beg_auxvector((unsigned long int)&c, STACK_UPPER_BOUND);

    // Use strace to verify to check the value passed to exit
    if (aux)
        __exit(aux[AT_PAGESZ_ORD].val);
    else
        __exit(0);
}
