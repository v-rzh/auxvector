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
.AT_HWCAP       resd 1
.AT_HWCAP_VAL   resd 1
.AT_PAGESZ      resd 1
.AT_PAGESZ_VAL  resd 1
.AT_CLKTCK      resd 1
.AT_CLKTCK_VAL  resd 1
.AT_PHDR        resd 1
.AT_PHDR_VAL    resd 1
.AT_PHENT       resd 1
.AT_PHENT_VAL   resd 1
.AT_PHNUM       resd 1
.AT_PHNUM_VAL   resd 1
.AT_BASE        resd 1
.AT_BASE_VAL    resd 1
.AT_FLAGS       resd 1
.AT_FLAGS_VAL   resd 1
.AT_ENTRY       resd 1
.AT_ENTRY_VAL   resd 1
.AT_UID         resd 1
.AT_UID_VAL     resd 1
.AT_EUID        resd 1
.AT_EUID_VAL    resd 1
.AT_GID         resd 1
.AT_GID_VAL     resd 1
.AT_EGID        resd 1
.AT_EGID_VAL    resd 1
.AT_SECURE      resd 1
.AT_SECURE_VAL  resd 1
endstruc

global get_beg_auxvector

get_beg_auxvector:
    mov ebx, 0xffffffff
    mov eax, esp
    and eax, 0xfffffffc
    .loop:
        mov ecx, [eax + auxvector_ord.AT_HWCAP]
        cmp ecx, AT_HWCAP
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_PAGESZ]
        cmp ecx, AT_PAGESZ
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_CLKTCK]
        cmp ecx, AT_CLKTCK
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_PHDR]
        cmp ecx, AT_PHDR
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_PHENT]
        cmp ecx, AT_PHENT
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_PHNUM]
        cmp ecx, AT_PHNUM
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_BASE]
        cmp ecx, AT_BASE
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_FLAGS]
        cmp ecx, AT_FLAGS
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_ENTRY]
        cmp ecx, AT_ENTRY
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_UID]
        cmp ecx, AT_UID
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_EUID]
        cmp ecx, AT_EUID
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_GID]
        cmp ecx, AT_GID
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_EGID]
        cmp ecx, AT_EGID
        jne .next
        mov ecx, [eax+ auxvector_ord.AT_SECURE]
        cmp ecx, AT_SECURE
        je .done
    .next:
        inc eax
        cmp eax, ebx
        jne .loop
        xor eax, eax

    .done:
        ret
