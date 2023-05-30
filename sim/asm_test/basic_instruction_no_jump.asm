addi r1, r1, #10
addi r2, r2, #5
nop
nop
nop
add r3, r1, r2
and r4, r1, r2
andi r5, r1, #0xFFFF
or r6, r1, r2
ori r7, r1, #0x0005
sge r8, r1, r2
sgei r9, r1, #0x0009
sle r10, r2, r1
slei r11, r1, #0x000B
sll r12, r1, r2
slli r13, r1, #0x0001
sne r14, r1, r2
snei r15, r1, #0xFFFF
srl r16, r1, r2
srli r17, r1, #0x0001
sub r18, r1, r2
subi r19, r1, #0x0002
xor r20, r1, r2
xori r21, r1, #0x000C
nop
nop
nop
sw 0(r3), r2
nop 
nop
nop
sw 1(r3), r2
nop
nop
nop
lw r4, 1(r3)
nop
nop
nop
lw r5, 0(r3)
