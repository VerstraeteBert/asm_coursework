$include(c8051f120.inc)

cseg at 000H ; cseg -> waar volgende code (machinecode) in prog. geheugen moet worden weggeschreven 
	jmp main ; eerste instructie is een jump om te voorkomen dat interruptvectoren niet worden overschreven

cseg at 0050H ; waar rest v programma moet weggeschreven worden

main: clr EA
	mov WDTCN,#0DEH  ; this block disables WDT (Watchdog Timer) to ensure the app keeps running
	mov WDTCN,#0ADH
	setb EA

	mov SFRPAGE,#0FH 
	mov XBR2,#40H
	mov P1MDOUT,#40H ; P1.6 output mode
	mov P1,#40H	  ; P1.6=3.3V
	jmp $ ; programma eindigen met oneindige lus
END
