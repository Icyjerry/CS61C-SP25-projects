addi t0, x0, -1
addi t1, x0, 1
addi s0, x0, 0
bltu t0, t1, not_less
addi s0, s0, 1
not_less:
bgeu t0, t1, greater
addi s0, s0, 16
greater:
bltu t1, t0, less
addi s0, s0, 32
less:
bgeu t1, t0, not_ge
addi s0, s0, 2
not_ge:
addi a0, s0, 0
