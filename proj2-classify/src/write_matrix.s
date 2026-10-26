.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    
    addi sp, sp, -48
    sw ra, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw s2, 20(sp)
    sw s3, 24(sp)
    sw s4, 28(sp)
    sw s5, 32(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    li a1, 1
    jal ra, fopen
    li t0, -1
    beq t0, a0, fopen_error
    mv s4, a0
    
    sw s2, 0(sp)
    sw s3, 4(sp)
    mv a0, s4
    mv a1, sp
    li a2, 2
    li a3, 4
    jal ra, fwrite
    li s5, 2
    bne a0, s5 fwrite_error
    
    mv a0, s4
    mv a1, s1
    mul s5, s2, s3
    mv a2, s5
    li a3, 4
    jal ra, fwrite
    bne a0, s5 fwrite_error
    
    mv a0, s4
    jal ra, fclose
    bne x0, a0, fclose_error


    # Epilogue
    lw ra, 8(sp)
    lw s0, 12(sp)
    lw s1, 16(sp)
    lw s2, 20(sp)
    lw s3, 24(sp)
    lw s4, 28(sp)
    lw s5, 32(sp)
    addi sp, sp, 48
    

    jr ra
    
 fopen_error:
    li a0, 27
    j exit
 
 fwrite_error:
    li a0, 30
    j exit
  
 fclose_error:
   li a0, 28
   j exit
 
