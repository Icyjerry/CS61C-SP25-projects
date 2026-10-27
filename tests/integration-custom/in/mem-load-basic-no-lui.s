addi s0, x0, 200
addi s1, x0, 0x15
slli s1, s1, 8
addi s1, s1, 0x26
slli s1, s1, 8
addi s1, s1, 0x37
slli s1, s1, 8
addi s1, s1, 0x48
sw   s1, 80(s0)
sw   s1, -20(s0)

lw   t0, 80(s0)
lh   t0, 80(s0)
lh   t1, 82(s0)
lb   t0, 80(s0)
lb   t1, 81(s0)
lb   t2, 82(s0)
lb   t0, 83(s0)

lw   t0, -204(s0)
lh   t0, -204(s0)
lh   t1, -202(s0)
lb   t0, -204(s0)
lb   t1, -203(s0)
lb   t2, -202(s0)
lb   t0, -201(s0)
