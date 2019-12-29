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
	mov R0,SP 
	push 01H 
 	push Acc
	dec R0 ; PC neemt 2 plaatsen in op stack
	dec R0
	dec R0
	mov A, @R0 ; A = 3
	dec R0
	mov 01H,@R0 ; R1 = 20H
	inc R0
	dec A ; A = offset
	add A,R1 ; A = 2 + 20H = 22H 
	mov R1,A ; R1 = 22H
	; mov @R0,@R1 ; dit gaat niet, met hulpregister werken
	mov A, @R1 ; A = -1
	mov @R0, A ; [stapeladres] = -1 
	pop Acc
	pop 01H
	pop 00H
	ret
END
