# CS3520 Lab 4 - p3-loaduse.s
# a = x + y ;  b = z - w   (x, y, z, w are words in memory)
# Ripes starts gp (x3) at 0x10000000, the first address of .data,
# so gp is used as the base address and no setup instruction is needed.
        .data
x:      .word   8
y:      .word   3
z:      .word   5
w:      .word   2
a:      .word   0
b:      .word   0
        .text
main:
        lw      t0, 0(gp)           # t0 = x
        lw      t1, 4(gp)           # t1 = y
        add     t2, t0, t1          # t2 = x + y
        lw      t3, 8(gp)           # t3 = z
        lw      t4, 12(gp)          # t4 = w
        sub     t5, t3, t4          # t5 = z - w
        sw      t2, 16(gp)          # a = t2
        sw      t5, 20(gp)          # b = t5
