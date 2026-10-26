.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    li t2, 0
    li t3, 1
    li t4, 0   #index
    li t5, 0x80000000   #number
    
    blt a1, t3, error

loop_start:
    bge t2, a1, loop_end
    slli t1, t2, 2
    add t1, a0, t1
    lw t0, 0(t1)
    
    bge t5, t0, loop_continue
    mv t4, t2
    mv t5, t0

loop_continue:
    addi t2, t2, 1
    j loop_start

loop_end:
    # Epilogue
    mv a0, t4
    jr ra
    
error:
    li a0, 36
    j exit



