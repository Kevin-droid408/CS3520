# CS3520 Lab 4 - p1-independent.s
# Eight instructions with NO dependences between them and no branches.
# Nothing here can stall: this is the pipeline's best case.
        .text
main:
        addi    t0, zero, 10
        addi    t1, zero, 20
        addi    t2, zero, 30
        addi    t3, zero, 40
        addi    t4, zero, 50
        addi    t5, zero, 60
        addi    t6, zero, 70
        addi    s1, zero, 80
