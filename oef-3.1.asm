$include(c8051f120.inc)

cseg at 000H
	jmp main

cseg at 0050H

main: 
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	mov SFRPAGE,#0FH
	mov XBR2,#40H
	mov P1MDOUT,#0FFH
	mov 20H,#3FH ;bitpatroon 111111
	mov 21H,#06H ;bitpatroon 000110
	mov 22H,#5BH
	mov 23H,#4FH
	mov 24H,#66H
	mov 25H,#6DH
	mov 26H,#7DH
	mov 27H,#07H
	mov 28H,#7FH
	mov 29H,#6FH
	
	mov R2,#00H; teller

start:	
	jb P3.7,$
	jnb P3.7,$
	inc R2
	cjne R2,#10d,schrijf ;compare and jump if not equal
	mov R2,#00H

schrijf:
	mov A,#20H
	add A,R2
	mov R0,A
	mov P1,@R0 ;equivalent voor * in c(R0 is een pointer)
	jmp start
END
