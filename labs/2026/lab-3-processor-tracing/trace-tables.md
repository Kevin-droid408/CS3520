# CS3520 Lab 3: Trace Tables

## Step 3: Tracing `add t2, t0, t1` (x7 = x5 + x6)

Setup: Ripes, RISC-V Single Cycle Processor, Extended layout. Loaded `trace-classes.s` and clocked until PC = 0x00000008. At this point t0 = 12 and t1 = 5.

|    Element   |         Port            |                     Value                    |
|--------------|-------------------------|----------------------------------------------|
| pc_reg       | out                     | 0x00000008                                   |
| pc_4         | out                     | 0x0000000c (8 + 4)                           |
| instr_mem    | data_out                | 0x006283B3                                   |
| decode       | r1_reg_idx / r2_reg_idx | 5 / 6 (t0 = x5, t1 = x6)                     |
| decode       | wr_reg_idx              | 7                                            |
| control      | reg_do_write_ctrl       | 1 (register file write-enable wire is green) |
| control      | alu_op2_ctrl            | REG2 (second register, not the immediate)    |
| registerFile | r1_out / r2_out         | 12 / 5                                       |
| alu_op1_src  | out                     | 12                                           |
| alu_op2_src  | out                     | 5                                            |
| alu          | res                     | 17 (0x11)                                    |
| data_mem     | wr_en                   | 0 (no store)                                 |
| reg_wr_src   | select / out            | ALURES (1) / 17                              |
| pc_src       | select / out            | 0 / 0x0000000c                               |
