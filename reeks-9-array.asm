$include(c8051f120.inc)

cseg at 0000H
      jmp main
cseg at 0050H
main: clr EA
      mov WDTCN, #0DEH
      mov WDTCN, #0ADH
      setb EA
      mov SFRPAGE,#0EH
      mov XBR2,#40H
			mov P1MDOUT,#0FFH
			mov 20H,#01001000b  ; bitpatroon 0 ARRAY  IN ASM BOUWEN
			mov 21H,#01001000b   ; bitpatroon 1
			mov 22H,#01001000b
			mov 23H,#01001000b
			mov 24H,#01001000b
			mov 25H,#01001000b
			mov 26H,#01001000b
			mov 27H,#01001000b
			mov 28H,#01001000b
			mov 29H,#01001000b


			start: jb P3.7,$
						 jnb P3.7,$
						 inc R2
						 cjne R2,#10d, schrijf ; compare jump not equal(x, y, callback) ; R2 is teller 
						 mov R2,#00d

		  schrijf: mov A, #20H
							 add A, R2 (R0 als pointer, (tab+idx))
							 mov R0,A
							 mov P1,@R0 ; p1 => *(tab + R2) (WAARDE VAN R0 NAAR P1 WESGSCHRIJVEN)
							 jmp start
