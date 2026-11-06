# p5-unrolled.s - unrolled by two (two elements per iteration) and scheduled.
        .data
arr:    .word   3, 1, 4, 1, 5, 9, 2, 6
total:  .word   0
        .text
main:
        addi    t0, gp, 0           # t0 = address of arr[0]
        addi    t1, zero, 8         # t1 = elements left
        addi    t2, zero, 0         # t2 = sum
loop:
        lw      t3, 0(t0)           # arr[i]
        lw      t4, 4(t0)           # arr[i+1]
        addi    t0, t0, 8           # advance two elements
        addi    t1, t1, -2          # two fewer left
        add     t2, t2, t3
        add     t2, t2, t4
        bne     t1, zero, loop
        sw      t2, 32(gp)          # total = sum
