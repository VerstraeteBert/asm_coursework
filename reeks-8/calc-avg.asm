; gemiddelde waarde in een array berekenen
; ervan uitgaande dat alles mooi past in 8 bit

cseg at 0000H
	jmp main
cseg at 0050H

main:
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	mov 20H,#2d
	mov 21H,#3d
	mov 22H,#4d
	mov 23H,#5d
	mov 24H,#6d
	mov 25H,#7d
	mov 26H,#8d
	mov 27H,#9d

	mov R0,#20H
	mov R1,#8d

	; calc avg
	call avg

	jmp $

avg:
	push 00H
	push 01H
	push PSW
	clr A
	mov B,R1

loop:
	add A,@R0
	inc R0
	djnz R1,loop
	div A,B ; res in A, rem in B
	pop PSW
	pop 01H
	pop 00H
	ret	
END
