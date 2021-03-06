Laatste les notities

 ;ADC programma:
 
 clr EA
 mov WDTCN,#0DEH
 mov WDTCN,#0ADH
 setb EA
 
 mov SFRPAGE,#0FH
 mov XBR2,#40H  ;crossbar nodig -> temp sensor waardes uitschrijven naar display
 mov P0MDOUT,0FFH
 mov P1MDOUT,#0FFH  ; 3 poorten nodig -> decimaal, tiental en 100-tal
 mov P2MDOUT,#0FFH
 
 MOV SFRPAGE,#00H
 ; ref spanning -> zie p 107
 
 ; REF0CN -> conf voor temp sensor (p108)
 ; bit 7-5 (don't care)
 ; ADC0 voltage moet referentiespanning nemen van vref2 PIN (niet van ADC out) -> bit 4 moet 0 zijn
 ; TEMPE aan (temp ENABLE) -> bit 2 moet 1 zij
 ; BIASE: bit 1 : must be 1 if using ADC
 ; REFBE (Internal reference enbable bit) -> interne referentiespanning (1) / externe ref (0), in dit geval dus 1
 mov REF0CN,#00000111b
 
 ; vertragingslus
 ; wachten op referentiespanning (zie p108) (VREF turn on time 1 <-> 2 condensatoren))
 ; 2.43V (gemmideld bij 25 C)
 mov R0,#255d
 loop:
  mov R1,#255d
  djnz R1,$
  mov R0, loop
 
 ; zie p 73
 ; selectie 0e rij
 ; rij adres
 mov AMX0CF,#00H
 ; kolom addr
 mov AMX0SL,#08H

; nu referentie spanning & temp sensor geconfigureerd

; conversie starten (p59)
: hier softwarematig (niet timer / rising edge)

(p 57 AD0CN)
setb AD0EN ; zet ADC0 aan (1) -> klaar voor conversies
           ; (0) low power mode -> als niet bezig met conversie minder stroom verbruiken
           ; nadeel ? -> duurt iets langer om conversie te starten
           
; AD0INT ; 1 -> klaar ; 0 -> conversie bezig
; AD0BUSY -> zelfde

; AD0CM1-0: ADC0 Start of Conversion Mode Select.
    ;If AD0TM = 0:
    ;00: ADC0 conversion initiated on every write of ‘1’ to AD0BUSY.
    ;01: ADC0 conversion initiated on overflow of Timer 3.
    ;10: ADC0 conversion initiated on rising edge of external CNVSTR0.
    ;11: ADC0 conversion initiated on overflow of Timer 2.

start:
  clr AD0INT
  setb AD0BUSY
  jnb AD0INT,$
  jmp start
  
; omzetten van digitale waarde -> spanning 
; spanning  = (digitale waarde * vref) / 2^12 (4096)
; Stel dig waarde (0590H) -> spanning is 0,0844
; digitale waarde / vref / 4096  = dig waarde 


; omzetten van spanning -> temperatuur  
; zie fig 5.2
; VTEMP = 0.00286 * (TEMPC) + 0.776
; -> TEMPC = (VTEMP - 0,776) / 0.00286

; omgekeerde berekening ook kennen :-)
; bv temp van 15 gr -> 0.8162v -> 564H (digitale waarde) (DISCREET! -> enkel gehele getallen) 
; er zal een kleine conversiefout zijn door de discretisatie (bij deze conversie is delta Temp -> 0,2 gr)
; 565H wordt dus 564H
; afrondingsfout van ong 1H (discreet)
; dus 15 + (ADC0L - 64H) * 0.2 gr C (dus delen door 5)
; vb hieronder

; lezen en conversie vb
start:
  clr AD0INT
  setb AD0BUSY
  jnb AD0INT,$
  
  mov A,ADC0L
  subb A,#64H
  
  mov B,#5d
  div AB ; hoeveel keer past delta C hierin?
  
  push B ; rest
  add A,#15d ; quot + 15


   ; getal per getal uit cijfer halen
  ; % (getalstelsel)
  ; / (getalstelsel)
 
  mov B,#10d
  ; tientallen in A
  div AB ; eenheden in B
  
  mov P2, A
  mov P1, B
  
  pop Acc ; rest bij deling ophalen
  rl A
  
  mov P0, A
  jmp start
