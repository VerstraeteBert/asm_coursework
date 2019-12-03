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
 
