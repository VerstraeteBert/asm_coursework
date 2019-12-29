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

	MOV XBR2,#40H
	mov P1MDOUT, #40H
	mov P1,#40H

	jmp $
END