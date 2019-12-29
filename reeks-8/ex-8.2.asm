int faculteit(int n) {
   if (n == 0) return 1;
   return n * factulteit(n - 1)
}


$include(c8051f120.inc)

cseg at 0000H
    jmp main
cseg at 0050H
 
main: 
   clr EA
   mov WDTCN,#0DEH
   mov WDTCN,#0ADH
   setb EA
   mov B,#5d
   push B
   call faculteit
   pop B ; lowbyte wordt in B gestokken (little endian systeem)
   jmp $

faculteit: 
   push 00H
   mov R0,SP
   dec R0
   dec R0
   dec R0
   push Acc
   mov A,@R0
   jnz recursie
   mov @R0,#1d
   pop Acc
   pop B
   pop 00H
   ret

recursie:
   dec A
   push Acc
   call faculteit
   pop B
   inc A
   mul AB
   mov @R0,A
   pop Acc
   pop 00H
   ret
END
