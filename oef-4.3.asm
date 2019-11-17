$include(c8051f120.inc)
 
cseg at 0000H
  jmp main
 
 
cseg at 0003H ; interrupts van interupt lijn 0 zie pg147
  jmp ISR_EX0 ;enable flag
cseg at 0013H ; zie pg147 interrupts vector
  jmp ISR_EX1 ;enable flag
 
 
cseg at 0060H  ;hier om memory overlap te voorkomen

main: 
  clr EA
  mov WDTCN,#0DEH
  mov WDTCN,#0ADH
  setb EA

  setb EX0 ;enable interrupts van lijn 0 enable flag zie pg147
  setb EX1 ;enable interrupts van lijn 1 enable flag zie pg147

  ; crossbar settings, bepaalde pinnen gedeeld ==> p0 instellen als interrupts lijn zie P217
  ; welke bit in welke register setten
  mov SFRPAGE,#0FH
  mov XBR2,#40H

  ; p0.0 wordt interupt line 0 (/int0)
  ;In table zien interupt 0 => op XBR1.2 == 2de bit zetten van XBR dus 0000 0100 (2de bit is 3de plaats)
  ;In table zien interupt 1 => op XBR1.4 == 4 de bit zetten 0001 0000

  ; als 2 interupt lijnen dan optellen
  ; 0000 0100
  ; 0001 0000
  ; 0001 0100 ==> 14H

  mov XBR1,#14H
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

  mov P0MDOUT,#00H ;input
  mov P1MDOUT,#0FFH ;output
  mov P2MDOUT,#0FFH
  mov P3MDOUT,#0FFH
  mov P4MDOUT,#0FFH
       
         
  mov SFRPAGE, #00H
  mov TMOD,#10H
  mov ckcon,#02H
  mov TH1,#6

  setb P0.4 ; voor input

  ; register zetten
  mov R2,#00H
  jmp $;
 
ISR_EX0: 
  setb P0.0 ; als knop niet ingeduwd zal er software matig de pin naar 1 forceren om sneller uit buffer zone te gaan
  clr R2
  reti
 
ISR_EX1: 
  setb P0.1 ; als knop niet ingeduwd zal er software matig de pin naar 1 forceren om sneller uit buffer zone te gaan
  mov R2,#00H
  reti
 
loop: 
  mov R4,#0FFH
  djnz R4,$
  djnz R3,loop
  jnb P0.0,ISR_EX0 ; terug opnieuw tot dat input uit buffer gebied is
  inc R2
  cjne R2,#10d, einde
  mov R2,#00d
  cpl P1.6
 
einde:  reti

END
