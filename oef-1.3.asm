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
      mov P3MDOUT, #00H ; P3.7=INPUT (moet eigenlijk niet gezegd worden, standaard op input)
      setb P1.6 ; P1.6 = 3.3V

start: jb P3.7,$ (jump if bit set) (1 als niet ingedrukt) (dus wacht tot indrukken)
       jnb P3.7,$  (jump if not bit set) (0 als ingedrukt) (dus wacht tot loslaten)
       cpl P1.6
       jmp start
