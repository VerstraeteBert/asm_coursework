$inlude(c8051f120.inc)

cseg at 0000H
	jmp main
cseg at 0050H

main:
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	mov SFRPAGE,#0FH
	mov XBR2,#40H

	mov P1MDOUT,#40H
	mov P3MDOUT,#00H

	mov R0,#0d

start:
	jb P3.7,$
	jnb P3.7,$
	inc R0
	inc R0 ; R0 + 2
	; knipperen
	mov A, R0
	mov R1,A

loop:
	mov R2,#255d

loop2:
	mov R3,#255d
	djnz R3,$
	djnz R2, loop2

	cpl P1.6
	djnz R1, loop

	jmp start
END
