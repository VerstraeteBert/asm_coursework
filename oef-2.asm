$include(c8051f120)

cseg at 0000H
	  jmp main

cseg at 0050H

main: clr EA
	  mov WDTCN,#0DEH
	  mov WDTCN,#0ADH   ; this block disables WDT (Watchdog Timer) to ensure the app keeps running
	  setb EA

	  mov SFRPAGE,#0FH
	  mov XBR2,#40H
	  mov P1MDOUT,#0FFH ; P1.6 output mode
	  mov P1,#0FFH      ; P1.6=3.3V

start: mov R2,#0FFH

loop: mov R3,#255D
	  djnz R3,$
	  djnz R2,loop 		; while(--R2)
	  cpl P1.6
	  jmp start
