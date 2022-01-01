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
