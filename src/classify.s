.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp, sp, -64
    sw ra, 12(sp)
    sw s1, 16(sp)   # argv
    sw s2, 20(sp)   # silent mode
    sw s3, 24(sp)   # m0
    sw s4, 28(sp)   # m1
    sw s5, 32(sp)   # input
    sw s6, 36(sp)   # m0 rows
    sw s7, 40(sp)   # m0 cols
    sw s8, 44(sp)   # m1 rows
    sw s9, 48(sp)   # m1 cols
    sw s10, 52(sp)  # h
    sw s11, 56(sp)  # o

    mv s1, a1
    mv s2, a2

    li t0, 5
    bne t0, a0, shell_error

    # Read pretrained m0
    lw a0, 4(s1)
    mv a1, sp
    addi a2, sp, 4
    jal ra, read_matrix

    lw s6, 0(sp)
    lw s7, 4(sp)
    mv s3, a0     # matrix m0

    # Read pretrained m1
    lw a0, 8(s1)
    mv a1, sp
    addi a2, sp, 4
    jal ra, read_matrix

    lw s8, 0(sp)
    lw s9, 4(sp)
    mv s4, a0     # matrix m1

    # Read input matrix
    lw a0, 12(s1)
    mv a1, sp
    addi a2, sp, 4
    jal ra, read_matrix

    mv s5, a0     # matrix in

    # Compute h = matmul(m0, input)
    lw t0, 4(sp)
    mul a0, s6, t0
    slli a0, a0, 2
    jal ra, malloc
    beqz a0, malloc_error
    mv s10, a0

    mv a0, s3
    mv a1, s6
    mv a2, s7
    mv a3, s5
    lw a4, 0(sp)
    lw a5, 4(sp)
    mv a6, s10   #h

    jal ra, matmul

    # Compute h = relu(h)
    mv a0, s10
    lw t0, 4(sp)
    mul a1, t0, s6
    jal ra, relu

    # Compute o = matmul(m1, h)
    lw t0, 4(sp)
    mul a0, t0, s8
    slli a0, a0, 2
    jal ra, malloc
    beqz a0, malloc_error
    mv s11, a0      # o

    mv a0, s4
    mv a1, s8
    mv a2, s9
    mv a3, s10
    mv a4, s6
    lw a5, 4(sp)
    mv a6, s11
    jal ra, matmul

    # Write output matrix o
    lw a0, 16(s1)
    mv a1, s11
    mv a2, s8
    lw a3, 4(sp)
    jal ra, write_matrix

    # Compute and return argmax(o)
    mv a0, s11
    lw t0, 4(sp)
    mul a1, s8, t0
    jal ra, argmax
    sw a0, 8(sp)    # classification

    # If enabled, print argmax(o) and newline
    bne x0, s2, end
    lw a0, 8(sp)
    jal ra, print_int
    li a0, '\n'
    jal ra, print_char

end:
    mv a0, s3
    jal ra, free
    mv a0, s4
    jal ra, free
    mv a0, s5
    jal ra, free
    mv a0, s10
    jal ra, free
    mv a0, s11
    jal ra, free

    lw a0, 8(sp)

    lw ra, 12(sp)
    lw s1, 16(sp)
    lw s2, 20(sp)
    lw s3, 24(sp)
    lw s4, 28(sp)
    lw s5, 32(sp)
    lw s6, 36(sp)
    lw s7, 40(sp)
    lw s8, 44(sp)
    lw s9, 48(sp)
    lw s10, 52(sp)
    lw s11, 56(sp)
    addi sp, sp, 64

    jr ra

malloc_error:
    li a0, 26
    j exit

shell_error:
    li a0, 31
    j exit
