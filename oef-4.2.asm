$include(c8051f120.inc)
 
cseg at 0000H
    jmp main
 
 
cseg at 0003H ; interrupts van interupt lijn 0
    jmp ISR_EX0
 
cseg at 0050H  ;hier om memory overlap te voorkomen
main: 
    clr EA
    mov WDTCN,#0DEH
    mov WDTCN,#0ADH
    setb EA

    setb EX0 ;enable interrupts van lijn 0

    ; crossbar settings, bepaalde pinnen gedeeld ==> p0 instellen als interrupts lijn zie P217
    ; welke bit in welke register setten
    mov SFRPAGE,#0FH
    mov XBR2,#40H
    mov XBR1,#04H ; p0.0 wordt interupt line 0 (/int0)
    mov P1MDOUT,#0FFH ;output
    mov P0MDOUT,#10H ;input
    clr P0.4 ; voor input
    clr P1.6

    ; register zetten
    mov R2,#00H
    jmp $
               
 
;ISR_EX0: ; interrupt code? CODE blijft herhalen,
; button niet meteen van 0-> 1, buffer zone met onbepaald getal erin => contact bounce
 
ISR_EX0: ; Tijd rekken in button curve om zo onpelaalde input weg te filteren, dubbele vertragings loop
    setb P0.0 ;software matig de pin naar 1 forceren om sneller uit buffer zone te gaan
    mov R3,#0FFH

loop: 
    mov R4,#0FFH
    djnz R4,$
    djnz R3,loop
    jnb P0.0, ISR_EX0 ; terug opnieuw tot dat input uit buffer gebied is
    inc R2
    cjne R2,#10d, einde
    mov R2,#00d
    cpl P1.6

einde:  reti
END
