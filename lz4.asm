	; Load platform specific routines and start program
	IFD TOS
	include tos.asm
	ELSE
	include tricky68k.asm
	ENDIF
	include utils.asm

	; Compress STRING, ouput in buffer
	lea.l	STRING,a3
	lea.l	BUFFER,a4

	; Create LZ4 frame
	jsr CreateFrame

	; Create LZ4 blocks
	jsr CreateBlocks

	; END PROGRAM
	bra Finish

CreateFrame:
	;Initial implementation focuses on mandatory specs and 
	;does not implement optional requirements

	;Frame descriptor
	;FLG 		BD 		(Content Size) 	(Dictionary ID) 	HC
	;1 byte 	1 byte 	0 - 8 bytes 	0 - 4 bytes 		1 byte

	;The descriptor uses a minimum of 3 bytes, 
	;and up to 15 bytes depending on optional parameters.

	;FLG byte
	;BitNb 		7-6 		5 			4 			3 		2 			1 			0
	;FieldName 	Version 	B.Indep 	B.Checksum 	C.Size 	C.Checksum 	Reserved 	DictID

	;BD byte
	;BitNb 		7 			6-5-4 			3-2-1-0
	;FieldName 	Reserved 	Block MaxSize 	Reserved

	; Fet FLG
	; Version 1.6.2, B.Dependency, no B.Checksum, no C.Size, no C.Checksum, no DictID
	move.b 	#%01100000,(a4)+
	; Max block size 64Kb, for small memory capacity vintage computers
	move.b	#%01000000,(a4)+
	; Pre-calculated xxh32 checksum is '301a8268', using byte 2
	move.b	#$82,(a4)+
	rts

CreateBlocks:
	;lea 

	;String and LZ4 compressed data (v1.4+), obtained with CLI "lz4 -1"
STRING:		dc.b 'AAAAAAAAAABCCCCCCCCCCDEEEEEEEEEEFGGGGGGGGGGHIIIIIIIIIIJKKKKKKKKKKL'
			dc.b 'MMMMMMMMMMNOOOOOOOOOOPQQQQQQQQQQRSSSSSSSSSSTUUUUUUUUUUVWWWWWWWWWWX'
			dc.b 'YYYYYYYYYYZ',0
SSIZE:		dc.b 143
;MAGIC:		dc.b $04,$22,$4d,$18
	even
COMP:		dc.b                 $64,$40,$a7,$49,$00,$00,$00,$15,$41,$01,$00,$25
			dc.b $42,$43,$01,$00,$25,$44,$45,$01,$00,$25,$46,$47,$01,$00,$25,$48
			dc.b $49,$01,$00,$25,$4a,$4b,$01,$00,$25,$4c,$4d,$01,$00,$25,$4e,$4f
			dc.b $01,$00,$25,$50,$51,$01,$00,$25,$52,$53,$01,$00,$25,$54,$55,$01
			dc.b $00,$25,$56,$57,$01,$00,$d0,$58,$59,$59,$59,$59,$59,$59,$59,$59
			dc.b $59,$59,$5a,$0a,$00,$00,$00,$00,$41,$cf,$00,$23
	even
BUFFER:
MALLOC:		; Indicates end of program space