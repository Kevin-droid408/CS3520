        .data
msg:     .asciz "5! = "

        .text
        .globl main

main: 
        li a0, 5        # a0 = 5
        jal ra, fact    #call fact(num)
        mv s0, a0

        la a0, msg      # print message
        li a7, 4
        ecall

        mv a0, s0
        li a7, 1
        ecall

        li a7, 10       #exit
        ecall

fact:   
        addi sp, sp, -8          # allocate stack frame (ra + n)
        sw   ra, 4(sp)           # save return address
        sw   a0, 0(sp)           # save n (needed after recursive call)

        li   t0, 1
        ble  a0, t0, base_case   # if (n <= 1) goto base_case

        addi a0, a0, -1          # a0 = n - 1
        jal  ra, fact            # a0 = fact(n-1)

        lw   t1, 0(sp)           # t1 = original n
        mul  a0, t1, a0          # a0 = n * fact(n-1)
        j    done

base_case:
        li   a0, 1               # return 1

done:
        lw   ra, 4(sp)           # restore return address
        addi sp, sp, 8           # deallocate stack frame
        jr   ra                  # return to caller

