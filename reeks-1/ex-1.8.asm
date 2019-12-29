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

	mov SFRPAGE,#00H
	mov TMOD,#10H
	mov CKCON,#02H
	mov TH0,#06H
	mov TL0,#0C6H

	setb TR1

start:
	jnb TF1, $
	clr TR0
	mov TH0,#06H
	mov TL0,#0C5H
	setb TR0
	clr TF1
	cpl P1.6
	
	jmp start
END
