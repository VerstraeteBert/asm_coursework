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
      mov A, #0d

start: mov R1, #255d
loop: mov R0, #255d
	  djnz R0, $
      djnz R1, loop
      cpl A
      mov P1, A
      jmp start
