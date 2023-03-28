bits 32

extern get_beg_auxvector
global _start

_start:
    sub esp, 0x8
    push 0xffffffff
    push esp
    call get_beg_auxvector
    xor ebx, ebx
    test eax, eax
    jz end
    mov ebx, [eax + 0x2c] ; AT_PHNUM offt
end:
    mov eax, 1
    int 0x80
