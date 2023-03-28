#include "auxvector.h"

#if __WORDSIZE == 64
#define STACK_ALIGN     0xfffffffffffffff8
#else
#define STACK_ALIGN     0xfffffffc
#endif

unsigned long int aux_order[] = {
#define X(a,b) a,
    AUX_VECTOR_ORDER
#undef X
};


static int found_auxvector(struct aux_entry *stack_addr)
{
    int i;

    for (i=0;i<AUXVLEN;i++)
        if (stack_addr[i].id != aux_order[i]) return 0;

    return 1;
}

/* rsp and max_stack are stack addresses designating the scan
 * boundaries. An address of any local variable would do. rsp
 * is DWORD/QWORD aligned before the search begins.
 */
struct aux_entry *get_beg_auxvector(unsigned long int rsp, unsigned long int max_stack)
{
    unsigned long int *st_addr;

    st_addr = (unsigned long int *)(rsp & STACK_ALIGN);
    max_stack &= STACK_ALIGN;

    // adjust the upper boundary
    max_stack -= SCAN_VECTOR_SIZE;

    for (; (unsigned long int)st_addr < max_stack; st_addr++) {
        if (found_auxvector((struct aux_entry *)st_addr))
            return (struct aux_entry *)st_addr;
    }
    return (void *)0;
}
