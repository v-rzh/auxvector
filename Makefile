CC=gcc
LD=ld
NASM=nasm

CFLAGS= -Wall -nostdlib -pie -fpic -O3
BIN_C=auxvector.o
TESTMAIN32=test32.o
BIN32=auxvector32.o
TESTMAIN64=test64.o
BIN64=auxvector64.o
TESTELF=test.elf

ifeq ($(32bit), true)
	CFLAGS += -m32
	LDFLAGS=-melf_i386
	ASMFLAGS += -felf32
	BIN=$(BIN32)
	TEST=$(TESTMAIN32)
else
	CFLAGS += -D__WORDSIZE=64
	ASMFLAGS += -felf64
	BIN=$(BIN64)
	TEST=$(TESTMAIN64)
endif

ifeq ($(c), true)
	BIN=$(BIN_C)
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
	-rm $(BIN_C)
	-rm $(BIN32)
	-rm $(BIN64)
	-rm $(TESTMAIN32)
	-rm $(TESTMAIN64)
	-rm $(TESTELF)
