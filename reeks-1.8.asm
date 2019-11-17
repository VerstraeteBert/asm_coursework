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
			mov P1MDOUT,#0FFH
			mov SFRPAGE,#00H
			mov TMOD, #10H; Timer 1 mode 1; 16 bit timer
			mov CKCON,#02H; Sys clock / 48
			mov TH1,#06H ; high byte timer
			mov TL1,#0C6H ; low byte timer, vraag brecht
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
