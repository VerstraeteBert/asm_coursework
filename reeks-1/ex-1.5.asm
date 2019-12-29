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

	mov P1MDOUT,#FFH

	mov A,#0d

start:
	mov R0,#255d
loop:
	mov R1,#255d
	djnz R1,$
	djnz R0,loop

	cpl A
	mov P1,A

	jmp start
END
