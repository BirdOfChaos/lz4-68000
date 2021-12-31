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

	;String and LZ4 compressed data (v1.4+), obtained with CLI "lz4 -1"
STRING:		dc.b 'AAAAAAAAAABCCCCCCCCCCDEEEEEEEEEEFGGGGGGGGGGHIIIIIIIIIIJKKKKKKKKKKL'
			dc.b 'MMMMMMMMMMNOOOOOOOOOOPQQQQQQQQQQRSSSSSSSSSSTUUUUUUUUUUVWWWWWWWWWWX'
			dc.b 'YYYYYYYYYYZ',0
;MAGIC:		dc.b $04,$22,$4d,$18
COMPS:		dc.b $64,$40,$a7,$49,$00,$00,$00,$15,$41,$01,$00,$25
			dc.b $42,$43,$01,$00,$25,$44,$45,$01,$00,$25,$46,$47,$01,$00,$25,$48
			dc.b $49,$01,$00,$25,$4a,$4b,$01,$00,$25,$4c,$4d,$01,$00,$25,$4e,$4f
			dc.b $01,$00,$25,$50,$51,$01,$00,$25,$52,$53,$01,$00,$25,$54,$55,$01
			dc.b $00,$25,$56,$57,$01,$00,$d0,$58,$59,$59,$59,$59,$59,$59,$59,$59
			dc.b $59,$59,$5a,$0a,$00,$00,$00,$00,$41,$cf,$00,$23
BUFFER:		ds.w 128,0
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
	
