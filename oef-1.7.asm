$include(c8051f120.inc)

cseg at 0000H
      jmp main
cseg at 0050H
main: clr EA
      mov WDTCN, #0DEH
      mov WDTCN, #0ADH
      setb EA
      mov SFRPAGE,#0FH
      mov XBR2,#40H
      mov P1MDOUT, #40H ; P1.6=OUTPUT
      mov A, #1d,

start: mov P1, A 
       jnb P3.7, klik
       mov R0, #255d

loop: mov R1, #255d
      djnz R1, $
      djnz R0, loop
      jc right
      rl A
      jmp start

klik:
      jnb P3.7, $ 
      cpl C
      jmp start

right: rr A
       jmp start 
