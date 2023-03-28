CC=gcc
LD=ld
NASM=nasm

CFLAGS= -Wall -nostdlib -pie -fpic -O3
BIN=auxvector.o
TESTMAIN32=test32.o
TESTMAIN64=test64.o
TESTELF=test.elf

ifeq ($(32bit), true)
	CFLAGS += -m32
	LDFLAGS=-melf_i386
	ASMFLAGS += -felf32
	TEST=$(TESTMAIN32)
else
	CFLAGS += -D__WORDSIZE=64
	ASMFLAGS += -felf64
	TEST=$(TESTMAIN64)
endif

.PHONY: clean all test

default: $(BIN)

test: $(TESTELF)

%.o: %.asm
	$(NASM) -o $@ $^ $(ASMFLAGS)

%.o: %.c
	$(CC) -o $@ $^ -c $(CFLAGS)

$(TESTELF): $(TEST) $(BIN)
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	-rm $(BIN)
	-rm $(TESTMAIN32)
	-rm $(TESTMAIN64)
	-rm $(TESTELF)
