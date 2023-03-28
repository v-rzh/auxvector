# auxvector

Naive but effective method of scanning the stack for the auxiliary vector.

## Background

The order of first several auxiliary vector entries as defined in the linux
kernel source (`create_elf_tables()` in `fs/binfmt_fs.c`) has not changed since
`v2.6.12` (`3a93e40326c8f470e71d20b4c42d36767450f38f` last time I checked):
```c
        NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
        NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
        NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
        NEW_AUX_ENT(AT_PHDR, phdr_addr);
        NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
        NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
        NEW_AUX_ENT(AT_BASE, interp_load_addr);
        if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
                flags |= AT_FLAGS_PRESERVE_ARGV0;
        NEW_AUX_ENT(AT_FLAGS, flags);
        NEW_AUX_ENT(AT_ENTRY, e_entry);
        NEW_AUX_ENT(AT_UID, from_kuid_munged(cred->user_ns, cred->uid));
        NEW_AUX_ENT(AT_EUID, from_kuid_munged(cred->user_ns, cred->euid));
        NEW_AUX_ENT(AT_GID, from_kgid_munged(cred->user_ns, cred->gid));
        NEW_AUX_ENT(AT_EGID, from_kgid_munged(cred->user_ns, cred->egid));
        NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
```

That means there will be a predictable order of `struct aux_entry_64` `id`
values on the stack that likely marks the beginning of the auxiliary vector.

## Why not use `getauxval()` like a normal person?

The point of this code is to be able to find the auxiliary vector without
depending on libc or knowing the stack state. This can be useful as part
of elf parasite code.

## Usage

Run `make` and you can link the `auxvector.o` with your program. For a 32-bit
object run `make 32bit=true`.

Call `get_beg_auxvector()` from your code:

```c
struct aux_entry *get_beg_auxvector(unsigned long int rsp, unsigned long int max_stack);
```

`rsp` and `max_stack` represent the lower and upper bound of the stack scan respectively.
Both addresses will be QWORD/DWORD aligned (depending on bitness).

The function returns a pointer to `AT_HWCAP` auxiliary vector entry or `NULL` on error.

## Examples

Check out code in `test32.asm` and `test64.asm` for an example.

You can compile and link these examples with `make test 32bit=true` and
`make test` respectively.

Both examples will grab the `AT_PHNUM` value and pass it to the `exit` syscall.

```
[ab@gibson]$ make test
nasm -o test64.o test64.asm -felf64
gcc -o auxvector.o auxvector.c -c -Wall -nostdlib -pie -fpic -O3 -D__WORDSIZE=64
ld -o test.elf test64.o auxvector.o
...
[ab@gibson]$ strace ./test.elf
execve("./test.elf", ["./test.elf"], 0x7ffff5364500 /* 46 vars */) = 0
exit(5)                                 = ?
+++ exited with 0 +++
```
