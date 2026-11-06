# CS3520 Lab 4 - p2-dependent.s
# A short chain of read-after-write (RAW) dependences.
# Intended results: t2 = 12, t3 = 5, t4 = 24, t5 = 29
        .text
main:
        addi    t0, zero, 7         # I1  t0 = 7
        addi    t1, zero, 5         # I2  t1 = 5
        add     t2, t0, t1          # I3  t2 = 12
        sub     t3, t2, t0          # I4  t3 = 5
        slli    t4, t2, 1           # I5  t4 = 24
        add     t5, t3, t4          # I6  t5 = 29
