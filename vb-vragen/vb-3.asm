; vb 3
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
	clr EA 
 	mov WDTCN #0DEH 
	mov WDTCN,#0ADH 
	setb EA 
	mov A,#253d
	mov R7,A ; opslaan om te gebruiken voor de verschillende machtsberekeningen
	mov B,#0d
	
maal2: 
	clr C
	rlc A ; A x 2
	push Acc 
	mov A, B ; 
	rlc A ; carry bit toevoegen in B
	mov B, A
	pop Acc ; Acc = LSB x 2
		; B = MSB x 2 + carry
	push Acc
	push B
	mov R6, #5d ; vijf iteraties ( 2^5)
	
maal32:
	clr C
	rlc A ; MSB x 2 x 2
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
