; bereken gemiddelde waarde in een array
; res optellen kan groter zijn dan 16 bit
; 1. alles in array optellen
; 2. delen door lengte arr

int calc_avg(int * arr, int len)
; resultaten mogen hier gewoon opgeslagen worden in rando registers
; al interessant genoeg

cseg at 0000H
	jmp main
cseg at 0050H

main:
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	mov 20H,#2d
	mov 21H,#144d
	mov 22H,#4d
	mov 23H,#200d
	mov 24H,#6d
	mov 25H,#128d
	mov 26H,#8d
	mov 27H,#9d


    ; input in
    ;  R0: geh adres eerst
    ;  R1: len
    call add_16b
    ; output R3 lsb
    ; R4 msb

    ; input in
    ;  R3: lsb deeltal
    ;  R4: msb deeltal
    ;  R1: deler
    call div_16b
    ;  A: quotiënt
    ;  B: rest

    jmp $

add_16b:
    push PSW
    push 00H
    push 01H
    mov R3,#00d
    mov R4,#00d
    clr C
    mov A,#0d

add_next:
    add A,@R0
    jnc skip_msb
    clr C
    inc R4

skip_msb:
    inc R0
    djnz R1, add_next

    mov R3,A

    pop 01H
    pop 00H
    pop PSW
    ret

div_16b:
    push PSW
    push 00H
    push 01H
    push 02H

    mov A,R3
    mov R2,#0d ; counter

clr_carry_and_subb:
    clr C

do_subb:
    subb A,R1
    inc R2 ; + 1 keer deelbaar
           ; als carry == 1 -> underflow
           ; msb dec met 1
    jnc do_subb

    dec R3 ; msb--

    cjne R3,#0FFH,clr_carry_and_subb
    ; als R3 == #0FFH
    ; dan was MSB al 0
    ; en LSB niet meer deelbaar

    ; subtractie te veel gedaan
    ; sinds de vorige lsb & msb niet meer deelbaar waren
    dec R2

    ; rest is dan de vorige lsb
    add A,R1
    
    mov B,A ; rest
    mov A,R2 ; quotiënt
    
    pop 02H
    pop 01H
    pop 00H
    pop PSW
    ret
END
