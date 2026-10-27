addi s0, x0, 128
addi s1, x0, 127
sw s1, 0(s0)
lw t0, 0(s0)
sb s1, 1(s0)
lb t1, 1(s0)
sh s1, 2(s0)
lh t2, 2(s0)
