addi s0, x0, 200
addi s1, x0, 0x87
slli s1, s1, 8
addi s1, s1, 0x65
slli s1, s1, 8
addi s1, s1, 0x43
slli s1, s1, 8
addi s1, s1, 0x21
sw   s1, 80(s0)
sw   s1, -20(s0)

lw   t0, 80(s0)
lh   t0, 80(s0)
lh   t1, 82(s0)
lb   t0, 80(s0)
lb   t1, 81(s0)
lb   t2, 82(s0)
lb   t0, 83(s0)
