cseg at 0000H
	jmp main
cseg at 0050H

main:
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	mov A,#230d
	mov B,#05d

	push Acc
	push B

	call verm

	pop B
	pop Acc

	jmp $

verm:
	push 00H
	mov R0,SP
	dec R0
	dec R0
	dec R0
	push Acc
	push B
	mov B,@R0
	dec R0
	mov A,@R0
	mul AB
	mov @R0,A
	inc R0
	mov @R0,B
	pop B
	pop Acc
	pop 00H
	ret
END