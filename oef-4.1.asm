$include(c8051f120.inc)
 
cseg at 000H
    jmp main
 
cseg at 0073H
    jmp ISR_TR3
 
cseg at 0080H ;overlap onmogelijk maken
 
main:
    clr EA
    mov WDTCN,#0DEH
    mov WDTCN,#0ADH
    setb EA
    mov EIE2,#01H ;setb ET3 is niet mogelijk want niet bit addresseerbaar
    mov SFRPAGE,#0FH
    mov XBR2,#40H
    mov P4MDOUT,#0FFH
    mov P2MDOUT,#0FFH
    mov P1MDOUT,#0FFH
    mov P0MDOUT,#0FFH
 
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
   
    mov P0,#20H
    mov P1,#20H
    mov P2,#20H
    mov P4,#20H
 
    mov SFRPAGE,#01H ; timer 3 pg
    mov TMR3CF,#08H; SYSCLK
    mov RCAP3H,#0F4H
    mov RCAP3L,#08H     ;1ms
    setb TR3
     
    mov R2,#00H
    mov R3,#00H
    mov R4,#00H
    mov R5,#00H
    jmp $
 
ISR_TR3:
    clr TF3 ; autoreload timer -> CAPL & CAPH niet resetten!
    inc R2
    cjne R2,#10d,uit
    mov R2,#00H
    inc R3
    cjne R3,#06H,uit
    mov R3,#00H
    inc R4
    cjne R4,#10d,uit
    mov R4,#00H
    inc R5
    cjne R5,#06d,uit
    mov R5,#00H
 
uit:
    mov A,#20H
    add A,R2
    mov R0,A
    mov P0,@R0
    mov A,#20H
    add A,R3
    mov R0,A
    mov P1,@R0
    mov A,#20H
    add A,R4
    mov R0,A
    mov P2,@R0
    mov A,#20H
    add A,R5
    mov R0,A
    mov SFRPAGE,#0FH
    mov P4,@R0
    reti
END
