	IFND TOS
	;For Tricky68k simulator
tty equ $FFE000     
	;Base address of the TTY memory-mapped device.
    ;Write to this address to write a character to the TTY, read from this
    ;address to read a character from the TTY. If -1 is read, the keyboard 
    ;buffer is empty and there is no character to read.

		public start		; Start code section, for Tricky68k simulator
start:
	ELSE  
    section code		; Start code section, for generating TOS binary	
	ENDIF

	; START PROGRAM



	; END PROGRAM
	IFD TOS
	;Wait for a key before returning
	move.w #1,-(sp) 	;$01 - ConIn	
	trap #1				;Call GemDos
	addq.l #2,sp	

 	clr.w -(sp)
	trap #1					;Return to OS
	ELSE
finish:
	bra finish
	ENDIF
	
	CLEARS:    dc.b 'First string to compress, contains repeated character AAAAAAA',0
	BUFFER:    ds.w 255,0
	even	
	
PrintChar:
	IFD TOS
	moveM.l d0-d7/a0-a7,-(sp)
		and.l #$00FF,d0	;Keep only Low Word
		move.w d0,-(sp) ;Char (W) to show to screen
		move.w #2,-(sp) ;$02 - ConOut (c_conout)
		trap #1			;Call GemDos
		addq.l #4,sp	;Remove 2 words from stack
	moveM.l (sp)+,d0-d7/a0-a7
	ELSE
	and.l #$00FF,d0	;Keep only Low Word
	move.w d0,tty
	ENDIF
	rts

NewLine:
	move.b #$0D,d0		;Char 13 CR
	jsr PrintChar
	move.b #$0A,d0		;Char 10 LF
	jsr PrintChar
	rts

PrintString:
	move.b (a3)+,d0			;Read a character in from A3
	beq PrintString_Done	;Return on NULL termination
	jsr PrintChar			;Print the Character
	bra PrintString
PrintString_Done:		
	rts
	
