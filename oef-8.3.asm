$include(c8051f120.inc)

cseg at 0000H
  jmp main

cseg at 0050H 

main: 
  clr EA
  mov WDTCN,#0DEH
  mov WDTCN,#0ADH
  setb EA
	
	mov 23H,#00 ; res locaties op 0 zetten
	mov 24H,#00
  mov R0,#120d ; orig mult waarden opslaan
  push 00H
  mov R7,#18d
  push 07H
  call verm
  mov SP,#07H ; orig stack locatie
  mov B,24H ; resultaten
  mov A,23H 
  jmp $ 

verm: 
	; multiplicant in 21H (msb) EN 20H (lsb)
	; multiplicator in 22H
	; res in 24H (msb) & 23H (lsb)
	; verder optimaliseren door grootste waarde als multiplicator
	push 00H ; 2 bytes
	mov R0,SP ; nu al pointen naar SP (om minder decrements te moeten maken tot mult getallen) 2
	push acc ; oud waarden pushen 2
	push B ; 2
	push 01 ; 2
	push PSW ; Dit bevat de carrybit (recovery na verm) 2
	dec R0 ; 1
	dec R0 ; 1
	dec R0 ; R0 point naar get 2 (bovenste) 1
	mov 20H,@R0 ; 2
	mov 21H,#00H ; 3
	dec R0 ; 2
	mov 22H,@R0 ; 3
	mov A,22H ; 2
	
loop:
	clr c ; 1
	rrc A ; c = lsb multiplier 2
	mov 22H,A
	jnc verder 
	clr c
	mov A,20H
	mov R1,23H
	mov 23H,A
	add A,R1
	mov A,24H
	mov R1,21H
 	addc A,R1 ; voegt beide toe (en voegt er automatisch nog de carry bit aan toe) 
					  ; carry bit word gecleared
	mov 24H,A ; <- sla res op in 24H

verder:
	clr c ; moet hier niet, verwijderd worden (carry bit is op dit punt sowieso 0)
	mov A,20H
	rlc A 
	push Acc
	mov A,21H
	rlc A
	mov 21H,A
	pop 20H ; <- orig acc waarde

	mov A,22H
	jnz loop
	
	pop psw ; boekhouding
	pop 01H
	pop B
	pop Acc
	pop 00H

	ret 
END
