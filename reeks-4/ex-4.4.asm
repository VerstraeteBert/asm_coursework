$include(c8051f120.inc)

; schrijf een programma dat op P1.7 een blokgolf genereert met een freq van 7KHZ
; 7KHZ -> 1 / 7000 -> volledige cycle
; 1 / 7000 / 2 -> respectievelijk low en high
; 24,5*10^6/8*(1/7000/2) = ong 219 -> past in 8 bit autoreload
; FFH - DBH = 24H -> autoreload waarde

; op P1.6 een blokgolf met freq 500HZ 
; 1 / 500 / 2 -> respectievelijk low en high
; 24,5*10^6/8*(1/7000/2) = 3062.5 -> 3062 -> 0BF6
; past niet in 8 bit -> 16 bit timer gebruiken (T1)
; FFFF- 0BF6 = F409 -> F4 high byte, 09 low byte

; wat als beide interrupts op hetzelfde moment gebeuren?
; best de hoge frequentie een hogere priority toewijzen want een 
; het verhandelen van de tweede interrupt kan zorgen voor een relatief
; groot verschil in golflengte, dit is minder het geval voor de blokgolf van 500hz

cseg at 0000H
	jmp main

cseg at 000BH
	jmp ISR_ET0

cseg at 001BH
	jmp ISR_ET1

cseg at 0050H

main:
	clr EA
	mov WDTCN,#0DEH
	mov WDTCN,#0ADH
	setb EA

	mov SFRPAGE,#0FH
	mov XBR2,#40H ; enable xbar to expose ports
	mov P1MDOUT,#0FFH ; P1.6, 1.7 out -> rest don't cares
	clr P1.6
	clr P1.7

	mov SFRPAGE,#0H

	mov TMOD,#12H ; t0 -> 8 bit autoreload ; t1-> 16b
	; config T0 (7KHZ cycle)
	mov TH0,#24H

	mov TL1,#09H
	mov TH1,#0F4H

	; enable overflow interrupts
	setb ET0
	setb ET1

	; high prio for T0 interrupt
	setb PT0

	; start timers
	setb TR0
	setb TR1

	jmp $

ISR_ET0:
	clr TF0
	cpl P1.7
	reti

ISR_ET1
	clr TF1
	cpl P1.6
	clr TR1
	mov TL1,#09H
	mov TH1,#0F4H
	setb TR1
	reti
END
