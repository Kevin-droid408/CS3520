        .data
array:  .word 12, 45, 7, 93, 28, 61, 4
size:   .word 7
SumIs:  .asciz "Sum of N integers: "

        .text
        .globl main

main:
        addi sp, sp, -4
        sw ra, 0(sp)

        la a0, array    # a0 = &array[0]
        lw a1, size     # a1 = 7
        jal ra, Sum  # Sum(array, 7) // function call
        mv s0, a0

        la a0, SumIs
        li a7, 4
        ecall

        li a7, 1
        mv a0, s0
        ecall

        lw ra, 0(sp)
        addi sp, sp, 4

        li a7, 10
        ecall

Sum:
        addi sp, sp, -16
        sw s0, 0(sp)
        sw s1, 4(sp)
        sw s2, 8(sp)
        sw s3, 12(sp)

        mv s0, a0
        mv s1, a1

        li s2, 0        # sum = 0
        li s3, 0        # init i = 0

for_loop:

        bge s3, s1, for_end
        slli t0, s3, 2
        add t0, s0, t0
        lw t1, 0(t0)

        add s2, s2, t1  #sum = sum + array[i]
        addi s3,s3, 1   #i++
        j for_loop

for_end:

        mv a0, s2

        lw s0, 0(sp)
        lw s1, 4(sp)
        lw s2, 8(sp)
        lw s3, 12(sp)
        addi sp, sp, 16
        ret 
