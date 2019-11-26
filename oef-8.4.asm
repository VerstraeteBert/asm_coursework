$include(c8051f120.inc)

cseg at 0000H
  jmp main

cseg at 0050H 
; eerst main schrijven (quotering :) )
main: 
  clr EA
  mov WDTCN,#0DEH
  mov WDTCN,#0ADH
  setb EA

	mov 20H, #11001100b
	mov 21H, #01010111b
	
	; prepare parameters (save)
	mov R0,#06H ; 
	push 00H ; 00H -> addr van R0
	call crc
	mov SP,#07H
	jmp $

;void crc(int * val)
; strategie in bepalen wat te pushen?
; -> probeer te anticiperen wat je nodig zal hebben
;	-> beter op safe spelen en wat extra pushen (en erna weer verwijderen als je die dan toch niet zou nodig hebben)
crc:
	push 00H
	mov R0, SP
	push Acc
	push B
	push 01H ; R1
	push 02H ; R2

	dec R0
	dec R0
	dec R0 ; R0 wijst nu naar 06H
	
	mov 01H,@R0 ; 01H is addr van R1 ; R1 wijst naar 06H
	mov @R1,#00H ; R1 gebruiken als CRC

	mov R0,#20H

terug:	
	cjne R0,#31H, bereken

	pop 02H
	pop 01H
	pop B
	pop Acc
	pop 00H

	ret

bereken: 
	mov R2, #8d
	mov A,@R0

loop:
	clr C
	rrc A
	push Acc
	mov A,@R1
	rlc A

	jnc check 
	; xor'n
	xrl A,#01010001b

check:
	mov @R1, A
	pop Acc
	djnz R2, loop
	inc R0
	jmp terug
	
END
