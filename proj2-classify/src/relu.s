.globl relu
.text
relu:
    # Prologue
    li t2, 0
    li t3, 1

    blt a1, t3, error

loop_start:
    bge t2, a1, loop_end
    slli t1, t2, 2
    add t1, a0, t1
    lw t0, 0(t1)

    bge t0, x0, loop_continue

    sw x0, 0(t1)

loop_continue:
    addi t2, t2, 1
    j loop_start

loop_end:
    # Epilogue
    jr ra

error:
    li a0, 36
    j exit