# CS3520 Lab 3: Google Form answers (Part A)

|  # | Question                                            |   Answer  |                     Where it comes from                        |
|----|-----------------------------------------------------|-----------|----------------------------------------------------------------|
| Q1 | Instructions listed in the Instruction memory panel |     18    | 17 source lines + 1 for `la` expanding to two instructions     |
| Q2 | Instructions never executed                         |     1     | Only `addi a2, zero, 99` at 0x30 is skipped by the taken `bne` |
| Q3 | CPI                                                 |   1.00    | Single cycle: one instruction per cycle                        |
| Q4 | `t4` after `lui t4, 0x2B`                           |   176128  | 0x2B << 12 = 0x0002B000                                        |
| Q5 | `t5` after `auipc t5, 0x0`                          |   20      | PC of the instruction is 0x14 = 20                             |
| Q6 | Encoding of `add t2, t0, t1`                        | 006283B3  | funct7 0000000, rs2 6, rs1 5, funct3 000, rd 7, opcode 0110011 |
| Q7 | Immediate generator output during `sw t2, 4(a0)`    |    4      | S-type offset                                                  |
| Q8 | `alu.res` during `sw t2, 4(a0)`                     | 268435460 | a0 (0x10000000) + 4 = 0x10000004                               |
| Q9 | Branch unit output during `beq t0, t1, skip`        |     0     | 12 != 5, condition false                                       |
| Q10 | `pc_src.select` during `bne t0, t1, target`        |     1     | Condition true, so PC is redirected                            |


