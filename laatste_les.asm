# zie tekening cursus
main:
  ...
	mov SFRPAGE,#0FH
	mov XBR2,#40H
	mov P4MDOUT,#40H ; P4.6 -> output

loop:
	mov C,P2.0
	anl C,P3.0 ; andlogic
	cpl C
	push PSW
  mov C, P4.1
	orl C, P3.7 ; orlogic
	anl C, F0
	mov P4.6, C
	jmp loop


; v2
; carry als input

main:
	mov SFRPAGE,#0FH
	mov XBR2,#40H
	mov P4MDOUT,#40H
	
loop: 
	mov Acc0, C ; (0 de bit van de Acc ; analoog aan P's)
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

	mov P5, A ; res in P5.6
	jmp loop
	
; Extra voorbeeld
; compile eens met gcc (masm-intel)
; 
int geef_laatste(int * tab, int n) {
	return tab[n - 1];
}

int main (void) {
	int t[3]  = {1, 6, -1};
	register int a = geef_laatste(t, 3);  ; register keyword -> niet naar hoofdgeheugen schrijven maar naar register
	P4 = a;
while (1); ; programma laten lopen :-)
	return 0;
}
	
; in asm
main:
	... ; WDT afzetten
	mov SFRPAGE,#0FH
	mov P4MDOUT,#0FFH
	mov 20H, #1d ; tab[0]
	mov 21H, #6d ; tab[1]
	mov 22H, #-1d ; tab[2] maak er 255 van achter de schermen (met msb) als sign bit
	; niet met push alle elementen op de stapel zetten! 
	; anders geef je de array door als value
	mov A,#20H
	push Acc
	mov B,#3d
	push B
	call geef_laatste
	pop B
	mov P4, B
	mov SP,#7H ; stackpointer resetten
	jmp $

geef_laatste:
	push 00H ; R0
	mov R0, SP 
	push 01H ; praktisch tijdens programma schrijven
			; gewoon al wat registers pushen om eventueel later te gebruiken
			;indien dan toch niet gebruikt, gewoon weer verwijderen
 	push Acc
	; push B
	dec R0 ; PC neemt 2 plaatsen in op stack
	dec R0
	dec R0
	mov A, @R0 ; A = 3
	dec R0
	mov 01H,@R0 ; R1 = 20H
	inc R0
	dec A ; A = C
	add A,R1 ; A = 2 + 20H = 22H ; Niet @R1 (anders value van 20H)
	mov R1,A ; R1 = 22H
	; mov @R0,@R1 ; dit gaat niet, met hulpregister werken
	mov A, @R1 ; A = -1
	mov @R0, A ; [stapeladres] = -1 
	pop Acc
	pop 01H
	pop 00H
	ret
END
	
; Volgend voorbeeld
; programma om registerwaarde te vermenigvuldigen met 257 (zonder gebruik van mult)
mov B, A
jmp $
; zie notas

; Vermenigvuldingen met 62,5 (zonder gebruik vna mult)
; opsplitsen in machten v/ twee
; A x 64 -> 6 keer verschuiven (nr links)
; A x 2 -> 1 keer verschuiven (nr links)
; A x 0,5 -> 1 keer verschuiven (nr rechts)
; Eerst éénmaal naar links ( A x 2 ) ! Deze waarde kan ook weer gebruikt worden A x 64 te bereekenen
main: 
	clr EA ; 2 bytes 
 	mov WDTCN #0DEH ; 3 bytes
	mov WDTCN,#0ADH ; 3 bytes
	setb EA ; 2 bytes
	mov A,#253d ; 2 bytes
	mov R7,A ; 1 byte opslaan om te gebruiken voor de verschikllende machtsberekeningen
	mov B,#0d
	
maal2: 
	clr C
	rlc A
	push Acc
	mov A, B
	rlc A
	mov B, A
	pop Acc ; Acc = LSB x 2
		; B = MSB x 2
	push Acc
	push B
	mov R6, #5d ; vijf iteraties ( 2^5)
	
maal32:
	clr C
	rlc A
	mov A,B
	rlc A
	mov B,A
	pop Acc
	djnz R6, maal32
	; A = LSB x 64
	; B = LSB x 64
	clr C
	pop 01H ; R1 = MSB x 2
	pop OOH ; R0 = LSB x 2
	
	subb A,R0 ; subtract with borrow (cijferrekenen)
	; A = LSB x 62
	
	push Acc
	mov A,B
	subb A,R1
	mov B,A ; B = MSB x 62
	push B
	
	; intiële waarde delen door 2
	mov A,R7
	clr C
	rrc A ; A = init / 2 ; rest bij deling zit in C
	
	pop 01H ; R1 -> MSB x 62
	pop 00H ; R0 -> LSB x 62
	
	; addc gebruiken kan ook, echter wss niet nodig in dit geval
	add A, R0 ; A = LSB x 60,5
	push Acc
	mov A,R1
	addc A,#00d
	mov B,A
	pop Acc
	
	jmp $
	
