.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    bge x0, a1, error
    bge x0, a2, error
    bge x0, a4, error
    bge x0, a5, error
    bne a2, a4, error

    # Prologue
    addi sp, sp, -48
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw ra, 24(sp)
    sw s0, 28(sp)
    sw s1, 32(sp)
    sw s2, 36(sp)

    li s0, 0       # a index
    li s1, 0       # b index
    mv s2, a6      # output pointer


outer_loop_start:
    bge s0, a1, outer_loop_end

    li s1, 0
inner_loop_start:
    bge s1, a5, inner_loop_end

    # Recompute the address of row i in m0 before calling dot.
    lw t3, 0(sp)
    mul t4, s0, a2
    slli t4, t4, 2
    add t3, t3, t4

    slli t2, s1, 2
    add t2, a3, t2  # b start point

    mv a0, t3
    mv a1, t2
    lw a2, 8(sp)
    li a3, 1
    mv a4, a5

    jal ra, dot
    sw a0, 0(s2)
    addi s2, s2, 4

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)

    addi s1, s1, 1
    j inner_loop_start

inner_loop_end:
    addi s0, s0, 1
    j outer_loop_start

outer_loop_end:


    # Epilogue
    lw ra, 24(sp)
    lw s0, 28(sp)
    lw s1, 32(sp)
    lw s2, 36(sp)
    addi sp, sp, 48

    jr ra

 error:
    li a0, 38
    j exit
