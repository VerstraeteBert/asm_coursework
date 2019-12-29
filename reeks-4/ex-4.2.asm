$include(c8051f120.inc)

cseg at 0000H
	jmp main

cseg at 0003H
	jmp ISR_EX0

cseg at 0050H

main:
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	mov SFRPAGE,#0FH
	mov XBR2
	setb EX0

	; toets layout p0.0 -> 0.3 zijn input lijnen
	; toets p0.4 -> 0.7 -> output
	; p0.0 low en p0.4 low? -> toets linksboven ingedrukt

	mov P1MDOUT,#0FFH
	clr P1.6

	mov P0MDOUT,#10H
	clr P0.4

	mov R2,#0d

	jmp $

;ISR_EX0: ; interrupt code? CODE blijft herhalen,
; button niet meteen van 0-> 1, buffer zone met onbepaald getal erin => contact bounce
ISR_EX0:
	setb P0.0 ; softwarematig p0.0 -> high om sneller uit buffer zone te geraken
	mov R3,#255d
loop:
	mov R4,#255d
	djnz R4,$
	djnz R3,loop
	jnb P0.0,ISR_EX0
	inc R2
	jne R2,#10d,einde
	mov R2,#0d
	cpl P1.6

einde:
	reti
	