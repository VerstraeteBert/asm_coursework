$include(c8051f120.inc)

cseg at 0000H
	jmp main

cseg at 0003H
	jmp ISR_EX0

cseg at 0013H
	jmp ISR_EX1

cseg at 000BH
	jmp ISR_TR0

cseg at 0050H

main:
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	MOV SFRPAGE,#0FH
	mov P1MDOUT,#0FFH
	mov P2MDOUT,#0FFH
	mov P3MDOUT,#0FFH
	mov P4MDOUT,#0FFH

	mov XBR2,#40H

	mov 20H,#3FH ;bitpatroon
    mov 21H,#06H
    mov 22H,#5BH
    mov 23H,#4FH
    mov 24H,#66H
    mov 25H,#6DH
    mov 26H,#7DH
    mov 27H,#07H
    mov 28H,#7FH
    mov 29H,#6FH

    mov R2,#00H ; ms
    mov R3,#00H ; tien ms
    mov R4,#00H ; honderd ms
    mov R5,#00H ; ms

    ; timer config
    mov SFRPAGE,#00H
    mov TH0,#0BFH ; reload val (1MS)
    mov TMOD,#02H ; T0 -> 8bit with autoreload
    mov CKCON,#02H; sysclk / 48

    ; keyboard config
    mov P0MDOUT,#10H ; p0.4 output
    clr P0.4

    mov SFRPAGE,#0FH
    ;0001 0100 <- INT0E & INT1E
    ; ext0 P0.0, P0.4
    ; ext1 P0.1, P0.4
    mov XBR1,#14H

    setb EX0 ; enable EX0 interrupt (start knop)

    jmp $

ISR_TR0:
	; increments timer values
	clr TF0 ; clr TF0 overflow

	inc R2
	jne R2,#10d,stop_interrupt
	mov R2,#0d

	inc R3
	jne R3,#10d,stop_interrupt
	mov R3,#0d

	inc R4
	jne R4,#10d,stop_interrupt
	mov R4,#0d

	inc R5
	jne R5,#10d,stop_interrupt
	mov R5,#0d

stop_interrupt:
	reti

ISR_EX0:
	; startknop
	setb P0.0
	mov SFRPAGE,#00H
	clr EX0 ; disable EX0 interrupt until stop button press
	setb ET0 ; enable timer interrupt until stop button press
	setb EX1 ; enable interrupt for button stop press
	setb TR0 ; enable timer 0

	mov R2,#0d
	mov R3,#0d
	mov R4,#0d
	mov R5,#0d

	jmp write ; reset counter display

ISR_EX1:
	; stop knop
	setb P0.0
	clr EX1
	clr ET0 ; disable timer 0
	setb EX0
	mov SFRPAGE,#00H
	clr TR0 ; disable TR0

write:
	mov A,#20H
	inc A,R2
	mov R0,A
	mov P1,@R0

	mov A,#20H
	inc A,R3
	mov R0,A
	mov P2,@R0

	mov A,#20H
	inc A,R4
	mov R0,A
	mov P3,@R0

	mov A,#20H
	inc A,R2
	mov R0,A
	mov SFRPAGE,#0FH
	mov P4,@R0
	mov SFRPAGE,#00H

	reti
END
