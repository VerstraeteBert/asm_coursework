;1.
  ; void crc(int * val)
  ; pointer naar CRC reg (in dit geval 06H meegeven) (meegeven als param)

;2.
  ; void crc(int * res, int * arr, int len)
  ; pointer naar CRC reg (in dit geval 06H meegeven) (meegeven als param)

;
; 1
;
$include(c8051f120.inc)

cseg at 0000H
  jmp main

cseg at 0050H

main: 
  clr EA
  mov WDTCN,#0DEH
  mov WDTCN,#0ADH
  setb EA

  mov 20H,#10101010b
  mov 21H,#10101111b
  mov 22H,#10101111b
  mov 23H,#10101111b
  mov 24H,#10101111b
  mov 25H,#10101111b
  mov 26H,#10101111b
  mov 27H,#10101111b
  mov 28H,#10101111b
  mov 29H,#10101111b
  mov 30H,#10101111b


  ; void crc(int * val)
  ; pointer naar CRC reg (in dit geval 06H meegeven) (meegeven als param)
  mov R0,#06H
  push R0
  call crc
  mov SP,#07H ; sp resetten

  jmp $

;void crc(int * val)
crc:
	push 00H
	mov R0,SP
	push 01H
	push 02H
	push PSW
	push Acc

	dec R0
	dec R0
	dec R0 ; R0 wijst nu naar 06H

	mov 01H,@R0 ; R1 wijst naar crc reg ; (linker operand Rn niet mogelijk)
	mov @R1,#0d ; crc register resetten
	
	mov R0,#20H ; R0 wijst naar eerst plek te CRC'n

	clr C

volgende_geh_plek_crc:
	mov R2,#8d ; 8 bits in crc te shiften
	mov A,@R0  ; A bevat nu te CRC'n 2 bytes

crc_per_bit:
	rrc A ; right shift te CRC'n, 
		  ; C bevat bit die in CRC gepushed moet worden

	push Acc ; resultaat opslaan 
	mov A,@R1 ; CRC in A
	rlc A ; crc naar links shiften 

	; als C == 1 -> crc algo uitvoeren 
	jnc next_bit

	xrl A,#01010001b
	clr C ; C clearen voor volgende iteratie

next_bit:
	mov @R1,A ; staat CRC opslaan in R1
	pop Acc ; Acc bevat nu weer de geshifte bytes van te CRC'n geh plek

	djnz R2, crc_per_bit ; 8 crc operaties per geh plek

	inc R0 ; R0 wijst naar volgende geheugenplek

	cjne R0,#31H, volgende_geh_plek_crc ; 20H -> 30H

	; klaar

	pop Acc
	pop PSW
	pop 02H
	pop 01H
	pop 00H

	ret


: 2
; extra oef
; void crc(int * res, int * arr, int len)
main: 
  ...

  mov 20H,#10101010b
  mov 21H,#10101111b
  mov 22H,#10101111b
  mov 23H,#10101111b
  mov 24H,#10101111b
  mov 25H,#10101111b
  mov 26H,#10101111b
  mov 27H,#10101111b
  mov 28H,#10101111b
  mov 29H,#10101111b
  mov 30H,#10101111b

  ; void crc(int * res, int * arr, int len)
  ; pointer naar CRC reg (in dit geval 06H meegeven) (meegeven als param)
  mov R0,#06H ; res
  push 00H

  mov R0,#20H ; begin_adr
  push 00H

  mov R0,#11d ; len
  push 00H

  call crc

  mov SP,#07H ; SP resetten (nog 3 items op stack)

  ; 06H bevat nu crc na verwerking

  jmp $

crc:
    push R0
    mov R0,SP
    dec R0
    dec R0
    dec R0
    push 02H
    push 01H
    push Acc
    push PSW
    push 04H

    mov R2,@R0 ; length
    dec R0
    mov R1,@R0 ; R1 bevat loc v/ begin_addr

    dec R0 ; R0 bevat locatie res
    mov @R0,#0d ; reset van inhoud crc register
    
    clr C ; initieel C clearen

init_crc_next_byte:
     mov A,@R1 ; A bevat inhoud volgende byte
     mov R4,#8d ; 8 bits per byte

do_crc_next_bit: ; (8x per byte)
    rrc A ; A bevat naar rechts geshifte inhoud v/ byte
          ; C bevat lsb

    push Acc ; geshifte byte opslaan

    mov A,@R0 ; A bevat CRC
    rlc A ; crc register naar links shiften
          ; met lsb zijnde de vorige lsb v/ te crc'n byte

    ; als C == 1 -> xor ; C == 0 volgende iteratie

    jnc next_iter_or_exit

    xrl A,#01010001b
    
    clr C ; C clearen voor volgende iter

next_iter_or_exit:
    mov @R0,A ; staat crc opslaan
    pop Acc ; shifted byte weer in A

    djnz R4, do_crc_bit

    inc R1 ; R1 point naar volgende te verwerken byte

    djnz R2,init_crc_for_next_byte ; len aantal bytes te verwerken

    ; klaar
    pop 04H
    pop PSW
    pop Acc
    pop 01H
    pop 02H
    pop 00H

    ret
END

