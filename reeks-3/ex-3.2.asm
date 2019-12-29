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

	mov P0MDOUT,#0FFH ; P0 output
	mov P1MDOUT,#0FFH ; P1 output
	mov P2MDOUT,#0FFH ; P2 output
	mov P4MDOUT,#0FFH ; P3 output

	mov P3,#0FFH ; P3 input

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

	mov R1,#0d
	mov R2,#0d
	mov R3,#0d

	jmp schrijf_3
	
start:
	jb P3.7,$
	jnb P3.7,$

	inc R1
	jne R1,#10d,schrijf_1
	mov R1,#0d

	inc R2
	jne R2,#10d,schrijf_2
	mov R2,#0d

	inc R3
	jne R3,#10d,schrijf_3

	jmp reset

schrijf_3:
	mov A,#20d
	add A,R3
	mov R0,A
	mov P1,@R0

schrijf_2:
	mov A,#20d
	add A,R2
	mov R0,A
	mov P2,@R0

schrijf_1:
	mov A,#20d
	add A,R1
	mov R0,A
	mov P2,@R0

	jmp start
	
END
