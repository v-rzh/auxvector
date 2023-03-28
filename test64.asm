bits 64

extern get_beg_auxvector
global _start

_start:
    sub rsp, 0x8
    mov rdi, rsp
    mov rsi, 0x7ffffffff000
    call get_beg_auxvector
    xor rdi, rdi
    test rax, rax
    jz end 
    mov rdi, [rax + 0x58] ; AT_PHNUM offt
end:
    mov rax, 0x3c
    syscall
