AllocateOnce:
	;Allocate memory. Takes size as long on stack. 
	;Returns address in a0
	move.w	#72,-(sp)
	trap	#1
	addq.l	#6,sp

Finish:
	;Wait for a key press
	move.w	#1,-(sp)
	trap 	#1
	addq.l	#2,sp	

	;Return to Desktop
 	clr.w	-(sp)
	trap	#1

PrintChar:
	and.l	#$00FF,d0
	move.w	d0,-(sp)
	move.w	#2,-(sp)	;ConOut
	trap	#1			;Call GemDos
	addq.l	#4,sp
	rts

	section	code		; Start code section, for generating TOS binary	