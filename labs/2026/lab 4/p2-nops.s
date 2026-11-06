# p2-nops.s - minimum nops so that p2 is correct on 5S-U (no forwarding, no hazard detection)
# Rule: a consumer must be >= 3 instructions after its producer. Each of the three
# adjacent dependences (I2->I3, I3->I4, I5->I6) needs 2 nops.
        .text
main:
        addi    t0, zero, 7         # I1
        addi    t1, zero, 5         # I2
        nop                         # } 2 nops: t1 is read by add (distance 1)
        nop                         # }
        add     t2, t0, t1          # I3  t2 = 12
        nop                         # } 2 nops: t2 is read by sub (distance 1)
        nop                         # }
        sub     t3, t2, t0          # I4  t3 = 5
        slli    t4, t2, 1           # I5  t4 = 24
        nop                         # } 2 nops: t4 is read by add (distance 1)
        nop                         # }
        add     t5, t3, t4          # I6  t5 = 29
