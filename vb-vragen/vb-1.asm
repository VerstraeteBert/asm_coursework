; vb vraag 1 (zie tekening cursus)

main:
  ...
	mov SFRPAGE,#0FH
	mov XBR2,#40H
	mov P4MDOUT,#40H ; P4.6 -> output

loop:
	mov C,P2.0
	andl C,P3.0
	mov F0,C

	mov C,P4.1
	orl C,P3.7

	andl C,F0

	mov P4.6,C

; spin off ; C als input -> kan C niet gebruiken voor bit ops
; v2
; carry als input

main:
	mov SFRPAGE,#0FH
	mov XBR2,#40H
	mov P4MDOUT,#40H
	
loop: 
	mov Acc.0, C ; (0 de bit van de Acc ; analoog aan P's)
	anl A, P2 ; Acc0 = C & P2.0
	cpl A ; Acc0 = inv(C & P2.0) 
	mov B,A
	mov A,P4 ; Acc1 = P4.1 

	; orl A, P3 ; DIT NIT DOEN: A -> 7e bit (msb) is de bit die we willen vergelijken ; dus eerst schuiven

	rr A ; 0000 0010 -> 0000 0001 
	rr A ; 0000 0001 -> 1000 0000 Acc 7 = P4.1
	orl A, P3 ; Acc 7 = P4.1 | P3.7
	rl A ; Acc 0 = P4.1 | P3.7

	; mov P4.6, Acc.6 ; ongeldig -> moet met carry 

	anl A, B ; 
	rr A ; 
	rr A ; Acc 6 = resultaat
	; P4 zou hier niet kunnen gebruikt worden als output, want deze fungeert ook als input

	mov P4, A ; res in P5.6
	jmp loop
