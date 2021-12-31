ASM=vasmm68k_mot
ASMFLAGS=-nocase -chklabels -Ftos

hello: lz4.asm
	$(ASM) $(ASMFLAGS) lz4.asm -L lz4.txt -o DEBUG.TOS -DTOS