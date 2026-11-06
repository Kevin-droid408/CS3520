.data
array:  .word 12, 45, 7, 93, 28, 61, 4
n:      .word 7
msg1:   .string "First larger integer: "
msg2:   .string "Second larger integer: "
nl:     .string "\n"

.text
.globl main

main:
    la   a0, array            # a0 = address of array
    la   t0, n
    lw   a1, 0(t0)            # a1 = size
    jal  ra, LargerIntegers

    li   a7, 10               # exit
    ecall

# void LargerIntegers(int arr[], int size)
# a0 = arr, a1 = size
# t2 = max1, t3 = max2
LargerIntegers:
    lw   t0, 0(a0)            # t0 = arr[0]
    lw   t1, 4(a0)            # t1 = arr[1]

    blt  t1, t0, first_bigger # if arr[0] > arr[1]
    mv   t2, t1               # else: max1 = arr[1]
    mv   t3, t0               #       max2 = arr[0]
    j    init_loop
first_bigger:
    mv   t2, t0               # max1 = arr[0]
    mv   t3, t1               # max2 = arr[1]

init_loop:
    li   t4, 2                # i = 2

loop:
    bge  t4, a1, print        # if i >= size, exit loop
    slli t5, t4, 2            # offset = i * 4
    add  t5, a0, t5           # address of arr[i]
    lw   t6, 0(t5)            # t6 = arr[i]

    ble  t6, t2, check_max2   # if arr[i] <= max1, check max2
    mv   t3, t2               # max2 = max1
    mv   t2, t6               # max1 = arr[i]
    j    next

check_max2:
    ble  t6, t3, next         # if arr[i] <= max2, skip
    mv   t3, t6               # max2 = arr[i]

next:
    addi t4, t4, 1            # i++
    j    loop

print:
    la   a0, msg1
    li   a7, 4                # print string
    ecall
    mv   a0, t2
    li   a7, 1                # print int
    ecall
    la   a0, nl
    li   a7, 4
    ecall

    la   a0, msg2
    li   a7, 4
    ecall
    mv   a0, t3
    li   a7, 1
    ecall
    la   a0, nl
    li   a7, 4
    ecall

    jr   ra                   # return