.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -32

    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)
    sw s4, 8(sp)

    # Save output pointers
    mv s1, a1
    mv s2, a2

    # fopen(filename, 0)
    li a1, 0
    jal ra, fopen
    blt a0, x0, fopen_error

    mv s0, a0

    # fread(fd, sp, 8)
    mv a0, s0
    mv a1, sp
    li a2, 8
    jal ra, fread

    li t0, 8
    bne a0, t0, fread_error

    # Read rows and cols
    lw t1, 0(sp)
    lw t2, 4(sp)

    # Store dimensions
    sw t1, 0(s1)
    sw t2, 0(s2)

    # Calculate size = rows * cols * 4
    mul s4, t1, t2
    slli s4, s4, 2

    # malloc(size)
    mv a0, s4
    jal ra, malloc
    beq a0, x0, malloc_error

    mv s3, a0

    # fread(fd, matrix, size)
    mv a0, s0
    mv a1, s3
    mv a2, s4
    jal ra, fread

    bne a0, s4, fread_error

    # fclose(fd)
    mv a0, s0
    jal ra, fclose

    bne a0, x0, fclose_error

    # Return matrix pointer
    mv a0, s3

    # Epilogue
    lw s4, 8(sp)
    lw s3, 12(sp)
    lw s2, 16(sp)
    lw s1, 20(sp)
    lw s0, 24(sp)
    lw ra, 28(sp)

    addi sp, sp, 32
    jr ra

malloc_error:
    li a0, 26
    j exit

fopen_error:
    li a0, 27
    j exit

fclose_error:
    li a0, 28
    j exit

fread_error:
    li a0, 29
    j exit