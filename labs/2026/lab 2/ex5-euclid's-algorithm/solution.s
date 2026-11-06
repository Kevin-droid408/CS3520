        .data
msg:    .asciz "GCD: "

        .text
        .globl main

main:
        li   a0, 48              # x = 48
        li   a1, 18              # y = 18
        jal  ra, GCD              # call GCD(x, y)
        mv   s0, a0               # save result

        la   a0, msg               # print "GCD: "
        li   a7, 4
        ecall

        mv   a0, s0                 # print the result
        li   a7, 1
        ecall

        li   a7, 10                  # exit
        ecall

# ---------------------------------------------
# int GCD(int a, int b)
#   a0 = a, a1 = b  (parameters, a0 also used as return value)
# ---------------------------------------------
GCD:
loop:
        beq  a1, x0, done         # while (b != 0) -- exit when b == 0
        mv   t0, a1               # temp = b
        rem  a1, a0, a1           # b = a % b
        mv   a0, t0               # a = temp
        j    loop

done:
        jr   ra                   # return a (already in a0)