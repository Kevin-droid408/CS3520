# p5-challenge.s - Step 19(c): correct on 5S-U with NO nops, and exactly as many cycles as on 5S-F.
# Every register is read at least 3 instructions after it was written (a 5S-U-safe schedule):
#   * the add uses the t3 loaded in the PREVIOUS iteration (software pipelining), so the loop
#     runs 9 times: the first add adds the initial t3 = 0, the 9th adds arr[7];
#     the 9th lw reads the word after the array (total = 0) and its value is never used;
#   * counter, accumulator and pointer are set up in an order that keeps distances >= 3.
# Relies on t3 being 0 at start (Ripes zero-initialises registers).
        .data
arr:    .word   3, 1, 4, 1, 5, 9, 2, 6
total:  .word   0
        .text
main:
        addi    t1, zero, 9         # iterations = 9
        addi    t2, zero, 0         # sum = 0
        addi    t0, gp, 0           # t0 = address of arr[0]
loop:
        addi    t1, t1, -1          # counter        (4 before the bne)
        add     t2, t2, t3          # sum += t3 loaded last iteration (4 after that lw)
        lw      t3, 0(t0)           # load next element
        addi    t0, t0, 4           # advance pointer
        bne     t1, zero, loop
        sw      t2, 32(gp)          # total = sum (4 after the add)
