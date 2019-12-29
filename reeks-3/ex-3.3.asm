$include(c8051f120.inc)
 
cseg at 000H
    jmp main
 
cseg at 0050H
 
main:
    clr EA
    mov WDTCN,#0DEH
    mov WDTCN,#0ADH
    setb EA
 
    mov SFRPAGE,#0FH ; xbr & pinnen 4 - 7 in F
    mov XBR2,#40H ; XBR aan

    mov P0MDOUT,#0FFH ; sec
    mov P1MDOUT,#0FFH ; tiental-sec
    mov P2MDOUT,#0FFH ; min
    mov P4MDOUT,#0FFH ; tiental-min P4 in sfrpage F, OK
    mov SFRPAGE,#00H

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

    mov CKCON,02H ; sys / 48
    mov TMOD,10H ; T1 in mode 1
    mov TH0,#06H
    mov TL1,#0C5H ; 1 sec

    setb TR1 ; start timer

    mov R2,#0d ; sec
    mov R3,#0d ; tiental-sec
    mov R4,#0d ; min
    mov R5,#0d ; tiental-min

start:
    jnb TF1,$
    clr TR1 ; reset clock
    clr TF1
    mov TH0,#06H
    mov TL1,#0C5H ; 1 sec
    setb TR1

    inc R2
    jne R2,#10d,schrijf_sec
    mov R2,#0d

    inc R3
    jne R3,#6d,schrijf_tien_sec 
    mov R3,#0d

    inc R4
    jne R4,#10d,schrijf_min
    mov R4,#0d

    inc R5
    jne R5,#6d,schrijf_tien_min
    mov R5,#0d

schrijf_tien_min:
    mov A,#20H
    add A,R5
    mov R0,A
    mov SFRPAGE,#0FH
    mov P4,@R0
    mov SFRPAGE,#00H

schrijf_min:
    mov A,#20H
    add A,R4
    mov R0,A
    mov P2,@R0

schrijf_tien_sec:
    mov A,#20H
    add A,R3
    mov R0,A
    mov P1,@R0

schrijf_sec:
    mov A,#20H
    add A,R2
    mov R0,A
    mov P0,@R0

	jmp start

END
