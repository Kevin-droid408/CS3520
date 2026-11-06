        .data
array:  .word 12, 45, 7, 93, 28, 61, 4
size:   .word 7
msg:    .asciz "Number of even numbers: "

        .text
        .globl main

main:   

        la a0, array                # a0 = base address of array
        lw a1, size
        jal ra, CountEvens          # call CountEvens(array, size)

        mv s0, a0

        la a0, msg                   # print msg "Number of even numbers"
        li a7, 4
        ecall

        mv a0, s0                    # print the value
        li a7, 1
        ecall

        li a7, 10
        ecall

CountEvens:
        li   t0, 0              # count = 0
        li   t1, 0              # i = 0
        li   t6, 2              # divisor
        mv   s1, a0             # s1 = base address of array
        mv   s2, a1             # s2 = size

loop:
        bge  t1, s2, done        # if i >= size, exit loop
        slli t2, t1, 2           # t2 = i * 4
        add  t4, s1, t2          # t4 = &array[i]
        lw   t3, 0(t4)           # t3 = array[i]
        rem  t3, t3, t6          # t3 = array[i] % 2
        bne  t3, x0, skip        # if odd, skip the increment
        addi t0, t0, 1           # count++
skip:
        addi t1, t1, 1           # i++
        j    loop

done:
        mv   a0, t0              # return count in a0
        jr   ra                  # return to caller