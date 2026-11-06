# CS3520 Lab 4 - p4-loop.s
# sum = n + (n-1) + ... + 1, computed with a counting-down loop.
# To repeat the experiment for another n, change ONLY the line marked "# n".
        .text
main:
        addi    t0, zero, 5         # n
        addi    t1, zero, 0         # sum = 0
loop:
        add     t1, t1, t0          # sum = sum + n
        addi    t0, t0, -1          # n = n - 1
        bne     t0, zero, loop      # repeat while n != 0
        addi    t2, zero, 1         # done = 1
        add     t3, t1, zero        # t3 = a copy of the sum
