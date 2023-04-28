%define AT_PHDR     3
%define AT_PHENT    4
%define AT_PHNUM    5
%define AT_PAGESZ   6
%define AT_BASE     7
%define AT_FLAGS    8
%define AT_ENTRY    9
%define AT_UID      11
%define AT_EUID     12
%define AT_GID      13
%define AT_EGID     14
%define AT_CLKTCK   17
%define AT_HWCAP    16
%define AT_SECURE   23

struc auxvector_ord
.AT_HWCAP       resq 1
.AT_HWCAP_VAL   resq 1
.AT_PAGESZ      resq 1
.AT_PAGESZ_VAL  resq 1
.AT_CLKTCK      resq 1
.AT_CLKTCK_VAL  resq 1
.AT_PHDR        resq 1
.AT_PHDR_VAL    resq 1
.AT_PHENT       resq 1
.AT_PHENT_VAL   resq 1
.AT_PHNUM       resq 1
.AT_PHNUM_VAL   resq 1
.AT_BASE        resq 1
.AT_BASE_VAL    resq 1
.AT_FLAGS       resq 1
.AT_FLAGS_VAL   resq 1
.AT_ENTRY       resq 1
.AT_ENTRY_VAL   resq 1
.AT_UID         resq 1
.AT_UID_VAL     resq 1
.AT_EUID        resq 1
.AT_EUID_VAL    resq 1
.AT_GID         resq 1
.AT_GID_VAL     resq 1
.AT_EGID        resq 1
.AT_EGID_VAL    resq 1
.AT_SECURE      resq 1
.AT_SECURE_VAL  resq 1
endstruc

global get_beg_auxvector

get_beg_auxvector:
    mov rbx, 0x7ffffffff000
    mov rax, rsp
    and rax, 0xfffffffffffffff8
    .loop:
        mov rcx, [rax + auxvector_ord.AT_HWCAP]
        cmp rcx, AT_HWCAP
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_PAGESZ]
        cmp rcx, AT_PAGESZ
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_CLKTCK]
        cmp rcx, AT_CLKTCK
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_PHDR]
        cmp rcx, AT_PHDR
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_PHENT]
        cmp rcx, AT_PHENT
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_PHNUM]
        cmp rcx, AT_PHNUM
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_BASE]
        cmp rcx, AT_BASE
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_FLAGS]
        cmp rcx, AT_FLAGS
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_ENTRY]
        cmp rcx, AT_ENTRY
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_UID]
        cmp rcx, AT_UID
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_EUID]
        cmp rcx, AT_EUID
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_GID]
        cmp rcx, AT_GID
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_EGID]
        cmp rcx, AT_EGID
        jne .next
        mov rcx, [rax+ auxvector_ord.AT_SECURE]
        cmp rcx, AT_SECURE
        je .done
    .next:
        inc rax
        cmp rax, rbx
        jne .loop
        xor rax, rax

    .done:
        ret
