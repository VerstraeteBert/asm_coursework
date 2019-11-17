$include(c8051f120.inc)

cseg at 0000H
      jmp main
cseg at 0050H
main: 
	clr EA
	mov WDTCN, #0DEH
	mov WDTCN, #0ADH
	setb EA
	mov SFRPAGE,#0FH ; xbr in F
	mov XBR2,#40H
	mov P1MDOUT,#0FFH
	mov SFRPAGE,#00H ; timers in 0
	mov TMOD, #10H; Timer 1 mode 1; 16 bit timer
	mov CKCON,#02H; Sys clock / 48
	;tijd berekenen ==> 2^16 - ( frequentie(=24.5 * 1 000 000) / 8 /48)(=63802 voor 1 sec) == verschil is decimaal getal ==naar hex *  
	mov TH1,#06H ; high byte timer, 2 hoogste bytes in hex
	mov TL1,#0C6H ; low byte timer, 2 laagste bytes in hex

	setb TR1 ; start timer, als 0 loopt de timer niet!

loop:
	jnb TF1,$ ;jump if bit not set (wacht tot timer overflow)
	mov TH1,#06H ; timer high opnieuw instellen
	mov TL1,#0C6H ; timer low opnieuw instellen
								; opnieuw instellen van low en high best zo snel mogelijk
								;, anders extra delay voor volgende overflow door uitvoering andere instructies
	clr TF1 ; bij timer 1 gebeurt dit automatisch, bij tr2, tr3, tr4 NIET. Toch best altijd expliciet schrijven
	cpl P1.6
	jmp loop	
END	
