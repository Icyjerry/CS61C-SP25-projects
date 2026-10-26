.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t2, 0  #index
    li t6, 0  #result
    bge t2, a2, error1
    bge t2, a3, error2
    bge t2, a4, error2

    # Prologue
    
loop_start:
    bge t2, a2, loop_end
    slli t1, t2, 2
    mul t0, t1, a3
    mul t1, t1, a4
    add t0, a0, t0
    add t1, a1, t1
    lw t3, 0(t0)  #a
    lw t4, 0(t1)  #b
    mul t5, t3, t4
    add t6, t5, t6
    
    
loop_continue:
    addi t2, t2, 1
    j loop_start

loop_end:

    # Epilogue
    mv a0, t6
    jr ra
    
 error1:
    li a0, 36
    j exit
 error2:
    li a0, 37
    j exit



