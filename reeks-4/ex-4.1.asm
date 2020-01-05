cseg at 0000H
    jmp main

cseg at 001BH
    jmp ISR_ET1
    
cseg at 0050H

main:
    clr EA
    mov WDTCN,#0DEH
    mov WDTCN,#0ADH
    setb EA

    mov SFRPAGE,#0FH
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

    ; P0,1,2,3 output
    mov P0MDOUT,#0FFH ; tiental min
    mov P1MDOUT,#0FFH ; min
    mov P2MDOUT,#0FFH ; tiental sec
    mov P3MDOUT,#0FFH ; sec

    mov R0,#20H
    mov R2,#0d ; sec
    mov R3,#0d ; tien sec
    mov R4,#0d ; min
    mov R5,#0d ; tien min


    mov SFRPAGE,#00H ; Timer con in 00H
    mov TMOD,#10H
    mov CKCON,#02H
    mov TH1,#06H
    mov TL1,#0C5H

    ; init display values 0 0 0 0
    mov P0,@R0
    mov P1,@R0
    mov P2,@R0
    mov P3,@R0

    setb TR1 ; start timer 1
    setb ET1 ; interrupt als T1 overflowed

    jmp $

ISR_ET1:
    ; reset timer
    clr TR1
    mov TH1,#06H
    mov TL1,#0C5H
    setb TR1
    clr TF1

    inc R2
    cjne R2,#10d,schrijf
    mov R2,#0d

    inc R3
    cjne R3,#6d,schrijf
    mov R3,#0d

    inc R4
    cjne R4,#10d,schrijf
    mov R4,#0d

    inc R5
    cjne R5,#6d,schrijf
    mov R5,#0d

schrijf:
    mov A,@R0
    add A,R2
    mov R1,A
    mov P3,@R1

    mov A,@R0
    add A,R3
    mov R1,A
    mov P2,@R1

    mov A,@R0
    add A,R4
    mov R1,A
    mov P1,@R1

    mov A,@R0
    add A,R5
    mov R1,A
    mov P0,@R1

    reti
END
