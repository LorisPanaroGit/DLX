addi r1, r1, #10
addi r2, r2, #5
nop
nop
nop
add r3, r1, r2
nop
nop
nop
bnez r3, fine
nop
nop
nop
addi r4, r4, #0x0002

ancora:
addi r5, r5, #0x00FF
beqz r6, step
nop
nop
nop

fine:
j ancora
nop
nop
nop


step:
addi r8, r8, #0x00CC
jal ending
nop
nop
nop
addi r9, r9, #0x00AA

ending:
addi r10, r10 #0x00BB

;the program must write "0x00FF" in r5, "0x00CC" in r8 and "0x00BB" in r10
;and must not write "0x0002" in r4 and "0x00AA" in r9
