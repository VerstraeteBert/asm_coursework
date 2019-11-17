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
    mov P1MDOUT,#0FFH
    mov P2MDOUT,#0FFH
    mov P4MDOUT,#0FFH
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
    mov R2,#08H; teller
    mov R3,#09H ;teller 2
    mov R4,#09H
    jmp schrijf3
 
start: 
    jb P3.7,$
    jnb P3.7,$
    inc R2
    cjne R2,#10d,schrijf ;compare and jump if not equal
    mov R2,#00H
    inc R3
    cjne R3,#10d,schrijf2 ;compare and jump if not equal
    mov R3,#00H
    inc R4
    cjne R4,#10d, schrijf3
    mov R4,#00H
 
 
schrijf3:
    mov A,#20H
    add A,R4
    mov R0,A
    mov P1,@R0
 
schrijf2:
    mov A,#20H
    add A,R3
    mov R0,A
    mov P2,@R0
 
schrijf:
    mov A,#20H
    add A,R2
    mov R0,A
    mov P4,@R0 ;equivalent voor * in c(R0 is een pointer)
    jmp start
    
