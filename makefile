all: sic

sic: vim.o
	gcc -g -Wall -o sic vim.o

vim.o: vim.asm
	nasm  -g -f elf64 -w+all -o vim.o vim.asm

.PHONY: clean
clean:
	rm -f *.o sic