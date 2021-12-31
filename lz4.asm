	IFND TOS
	;For Tricky68k simulator
tty equ 	$FFE000     
	public 	Start		; Start code section, for Tricky68k simulator
Start:
	ELSE
	;For Atari ST
    section	code		; Start code section, for generating TOS binary	
	ENDIF

	; START PROGRAM



	; END PROGRAM

	IFD TOS
	;Wait for a key press
	move.w	#1,-(sp)
	trap 	#1
	addq.l	#2,sp	

	;Return to Desktop
 	clr.w	-(sp)
	trap	#1
	ELSE
Finish:
	bra 	Finish
	ENDIF
	
CLEARS:		dc.b 'First string to compress, contains repeated character AAAAAAA',0
BUFFER:		ds.w 255,0
	even	
	
PrintChar:
	IFD TOS
	and.l	#$00FF,d0
	move.w	d0,-(sp)
	move.w	#2,-(sp)	;ConOut
	trap	#1			;Call GemDos
	addq.l	#4,sp
	ELSE
	and.l	#$00FF,d0
	move.w	d0,tty		;TTY output of tricky68k
	ENDIF
	rts

NewLine:
	move.b	#$0D,d0		;Char 13 CR
	jsr		PrintChar
	move.b	#$0A,d0		;Char 10 LF
	jsr		PrintChar
	rts

PrintString:
	move.b	(a3)+,d0
	beq		.printString_Done	;Return on NULL termination
	jsr		PrintChar
	bra		PrintString
.printString_Done:		
	rts
	
