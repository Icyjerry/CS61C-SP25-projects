addi t0, x0, 1
addi t1, x0, 2
addi s0, x0, 0
beq  t0, t1, not_equal
addi s0, s0, 1
not_equal:
beq  t0, t0, equal
addi s0, s0, 16
equal:
bne  t0, t0, same
addi s0, s0, 2
same:
bne  t0, t1, done
addi s0, s0, 32
done:
addi a0, s0, 0
