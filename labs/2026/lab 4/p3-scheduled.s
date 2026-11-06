# p3-scheduled.s - same eight instructions, reordered so 5S-F never stalls.
# Loads first; no load is followed immediately by an instruction that uses it.
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
        lw      t3, 8(gp)           # t3 = z
        lw      t4, 12(gp)          # t4 = w
        add     t2, t0, t1          # t2 = x + y   (t1 is 3 back: forwarded/in regfile)
        sub     t5, t3, t4          # t5 = z - w   (t4 is 2 back: MEM/WB -> EX)
        sw      t2, 16(gp)          # a = t2
        sw      t5, 20(gp)          # b = t5
