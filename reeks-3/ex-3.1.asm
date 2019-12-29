$include(c8051f120.inc)

cseg at 0000H
      jmp main
cseg at 0050H

main:
      clr EA
      mov WDTCN,#0DEH
      mov WDTCN,#0ADH
      setb EA

      mov SFRPAGE,#0FH
      mov XBR2,#40H

      mov P0MDOUT,#FFH

      mov P3MDOUT,#00H
      mov P3,#FFH

      mov 20H,#3FH ;bitpatroon 111111 ; 0
      mov 21H,#06H ;bitpatroon 000110 ; 1
      mov 22H,#5BH
      mov 23H,#4FH
      mov 24H,#66H
      mov 25H,#6DH
      mov 26H,#7DH
      mov 27H,#07H
      mov 28H,#7FH
      mov 29H,#6FH

      mov R1,#0d
      mov R0,#20H
      mov P0,@R0

start:
      jb P3.7,$
      jnb P3.7,$
      inc R1
      cjne R1,#10d,schrijf
      mov R1,#00H

schrijf:
      mov A,#20H
      add A,R1
      mov R0,A
      mov P0,@R0
      jmp start

END
