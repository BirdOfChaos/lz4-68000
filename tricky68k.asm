tty equ 	$FFE000 

AllocateOnce:
	;CALL ONLY ONCE!
	;Requires MALLOC label at end of program and data space
	;Dumb malloc. Will always return same value in subsequent calls
	;Ignores size requested and provides address after code and data
	move.l a0,MALLOC+100
	addq.l	#1,sp

Finish:
	bra 	Finish
	
PrintChar:
	and.l	#$00FF,d0
	move.w	d0,tty		;TTY output of tricky68k
	rts

	public 	start		; Start code section, for Tricky68k simulator
start:

