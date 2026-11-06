# CS3520 Lab 4 - p5-arraysum.s
# Sum the eight elements of an array and store the result.
        .data
arr:    .word   3, 1, 4, 1, 5, 9, 2, 6
total:  .word   0
        .text
main:
        addi    t0, gp, 0           # t0 = address of arr[0]
        addi    t1, zero, 8         # t1 = elements left
        addi    t2, zero, 0         # t2 = sum
loop:
        lw      t3, 0(t0)           # t3 = arr[i]
        add     t2, t2, t3          # sum = sum + arr[i]
        addi    t0, t0, 4           # next element
        addi    t1, t1, -1          # one fewer left
        bne     t1, zero, loop
        sw      t2, 32(gp)          # total = sum
