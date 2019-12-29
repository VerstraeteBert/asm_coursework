$include(c8051f120.inc)

cseg at 000H
	jmp main

cseg at 0050H

main: 
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	mov SFRPAGE,#0FH ;P 4 - 7 enkel direct addresseerbaar in #0FH
	mov XBR2,#40H
	mov P4MDOUT,#0FFH
	mov P2MDOUT,#0FFH
	mov P1MDOUT,#0FFH
	mov P0MDOUT,#0FFH

	mov SFRPAGE,#00H ;(timers direct addresseerbaar in #00H)
	mov TMOD,#10H ;timer 1 mode1: 16bit timer
	mov CKCON,#02H; gedeeld door 48
	mov TH1,#0ACH
	mov TL1,#0EDH ; seconde timer
	setb TR1

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

reset:
	mov R2,#00d; teller (minuten)
	mov R3,#00d; teller2 (tientallen minuten)
	mov R4,#00d; teller3 (uur)
	mov R5,#00d; teller4 (tiental uur)
	mov R6,#00d; seconden teller

	mov A,#20H
	add A,R2
	mov R0,A
	mov SFRPAGE,#0FH
	mov P4,@R0
	mov SFRPAGE,#00H

	mov A,#20H
	add A,R3
	mov R0,A
	mov P2,@R0

	mov A,#20H
	add A,R4
	mov R0,A
	mov P1,@R0

	mov A,#20H
	add A,R5
	mov R0,A
	mov P0,@R0

loop:
	jnb TF1,$ 
	mov TH1,#0ACH ;niets hiertussen steken!(instructies kosten tijd) dus direct timer herstarten
	mov TL1,#0EDH
	clr TF1	
	
	inc R6
	cjne R6,#60d,loop
	mov R6,#00H
	
	inc R2 
	cjne R2,#10d, schrijf_min ;compare and jump if not equal
	mov R2,#00H

	inc R3
	cjne R3,#06d,schrijf_tiental_min
	mov R3,#00H

	inc R4
	cjne R4,#10d,uur ; reset als R5 == 2 en R4 == 4
	mov R4,#00H

	inc R5
	cjne R5,#3d,schrijf_tiental_uur

schrijf_min:
	mov A,#20H
	add A,R2
	mov R0,A
	mov SFRPAGE,#0FH
	mov P4,@R0 ;equivalent voor * in c(R0 is een pointer)
	mov SFRPAGE,#00H
	jmp loop

schrijf_tiental_min:
	mov A,#20H
	add A,R3
	mov R0,A
	mov P2,@R0 ;equivalent voor * in c(R0 is een pointer)
	
	jmp schrijf_min

schrijf_uur:
	mov A,#20H
	add A,R4
	mov R0,A
	mov P1,@R0 ;equivalent voor * in c(R0 is een pointer)
	
	jmp schrijf_tiental_min

schrijf_tiental_uur:
	mov A,#20H
	add A,R5
	mov R0,A
	mov P0,@R0 ;equivalent voor * in c(R0 is een pointer)
	
	jmp schrijf_uur

uur:
	cjne R4,#04d,schrijf_uur
	cjne R5,#02d,schrijf_uur
	jmp reset
END
