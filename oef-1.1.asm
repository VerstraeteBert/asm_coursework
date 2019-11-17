$include(c8051f120.inc)

cseg at 000H
	jmp main

cseg at 0050H

main: clr EA
	mov WDTCN,#0DEH  ; this block disables WDT (Watchdog Timer) to ensure the app keeps running
	mov WDTCN,#0ADH
	setb EA

	mov SFRPAGE,#0FH 
	mov XBR2,#40H
	mov P1MDOUT,#0FFH ; P1.6 output mode
	mov P1,#0FFH	  ; P1.6=3.3V
	jmp $
