; vb 3
; programma om registerwaarde te vermenigvuldigen met 257 (zonder gebruik van mult)
; get x 256
; -> 8 shifts naar links
; MSB wordt LSB
; + 1 x LSB
; LSB behouden
; -> mov B,A
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

	mov A,#221d
	mov R7,A
	mov B,#0d

maal2:
	clr C
	rlc A
	push Acc ; lsb x 2
	mov A,B
	rlc A
	mov B,A
    pop Acc
    push Acc
	push B ; msb x 2

	mov R2,#5d

maal32:
	clr C
	rlc A
	push Acc
	mov A,B
	rlc A
	mov B,A
	pop Acc
	djnz R2,maal32

	clr C
	; A = lsb * 64
	; B = msb * 64

	; (x * 64) - (x * 2)
	pop 01H ; msb * 2
	pop 00H ; lsb * 2

	subb A,R0 ; A = LSB * 62
	push Acc ; LSB * 62 op stack
	mov A,B
	subb A,R1 ; A = MSB * 62
	mov B,A; B = MSB * 62

	; (x * 0,5)
	clr C
	mov A,R7
	rrc A ; x / 2

	; (x * 62 + x * 0,5)
	pop 00H ; LSB * 62

	; lsb * 62 + lsb * 0,5
	addc A,R0
	push Acc
	; + carry bit op msb
	mov A,B ; A = MSB * 62
	addc A,#00d

	mov B,A
	pop Acc
	; A = LSB ( x * 60,5)
	; B = MSB ( x * 60,5)

	jmp $
END
