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
      mov R2,#00d
      mov R3,#00d

start: jb P3.7,$
       jnb P3.7,$
       inc R2
       inc R2 ; overflow na 128 keer indrukken (8-bit register)
       mv A,R2
       mv R3,A

loop:
      mov R4, #255d

loop2: mov R5, #255d
       djnz R5,$
       djnz R4,loop2 ; dubbele vertragingslus
       cpl P1.6
       djnz R3, loop
       jmp start
END