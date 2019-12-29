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

	setb P1.6

start:
	jb P3.7,$
	jnb P3.7,$
	cpl P1.6
	jmp start

END
