$include(c8051f120.inc)

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

	mov 20H,#3FH ;bitpatroon
    mov 21H,#06H
    mov 22H,#5BH
    mov 23H,#4FH
    mov 24H,#66H
    mov 25H,#6DH
    mov 26H,#7DH
    mov 27H,#07H
    mov 28H,#7FH
    mov 29H,#6FH

    mov P0MDOUT,#0FFH
    mov P1MDOUT,#0FFH
    mov P2MDOUT,#0FFH
    mov P3,#0FFH

    mov R0,20H
    mov R2,#0d
    mov R3,#0d
    mov R4,#0d

    jmp schrijf_tien

loop:
	jb P3.7,$
	jnb P3.7,$

	inc R2
	cjne R2,#10d,schrijf_dec
	mov R2,#0d

	inc R3
	cjne R3,#10d,schrijf_tien
	mov R3,#0d

	inc R4
	cjne R4,#10d,schrijf_honderd
	mov R4,#0d

schrijf_tien:
	mov A,R3
	add A,R0
	mov R1,A
	mov P1,@R1

schrijf_dec:
	mov A,R2
	add A,R0
	mov R1,A
	mov P2,@R1

schrijf_honderd:
	mov A,R4
	add A,R0
	mov R1,A
	mov P0,@R1

	jmp loop
END
