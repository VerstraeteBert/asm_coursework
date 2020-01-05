cseg at 0000H
	jmp main
cseg at 0050H

main:
  clr EA
  mov WDTCN,#0DEH
  mov WDTCN,#0ADH
  setb EA

  mov 23H,#0d
  mov 24H,#0d

  mov R0,#101d
  push 00H
  mov R1,#1010d
  push 01H

  call verm

  mov A,23H
  mov B,24H

verm:
	push 00H
	mov R0,SP
	dec R0
	dec R0
	dec R0

	push Acc
	push PSW ; psw pushen (carry flag)
	push 01H 

	mov 20H,@R0
	mov 21H,#0d

	dec R0
	mov 22H,@R0
	
	mov A,22H

loop:
	clr C
	rrc A ; multiplicator naar rechts schuiven 
		  ; indien 1 -> resultaat optellen met huidige multiplicant
		  ; anders 0 -> niet optellen (resultaat multiplicatie is dan toch 0)

	mov 22H,A

	jnc verder

	clr C

	mov A,20H
	mov R1,23H
	add A,R1

	mov 23H,A

	mov A,24H
	mov R1,21H
	addc A,R1

	mov 24H,A

verder:
	mov A,20H
	rlc A
	mov 20H,A

	mov A,21H
	rlc A
	mov 21H,A

	mov A,22H

	jnz loop

	pop 01H
	pop PSW
	pop Acc
	pop 00H

	ret
