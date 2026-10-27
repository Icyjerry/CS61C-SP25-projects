addi t0, x0, -1
addi t1, x0, 1
addi s0, x0, 0
blt  t0, t1, less
addi s0, s0, 16
less:
bge  t0, t1, not_ge
addi s0, s0, 1
not_ge:
blt  t1, t0, not_less
addi s0, s0, 2
not_less:
bge  t1, t0, done
addi s0, s0, 32
done:
addi a0, s0, 0
