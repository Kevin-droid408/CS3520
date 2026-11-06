# CS3520 Lab 3, Part A: Trace Tables

Processor: RISC-V Single Cycle, Extended layout. Program: `trace-classes.s`.

## Instruction memory (as listed by the panel)

`la a0, val` is a pseudo-instruction and expands to `auipc` + `addi`, so the
source's 17 instruction lines become **18** real instructions.

| Addr | Encoding | Instruction | Executed? |
|------|----------|-------------|-----------|
| 0x00 | 00C00293 | addi t0, zero, 12 | yes |
| 0x04 | 00500313 | addi t1, zero, 5 | yes |
| 0x08 | 006283B3 | add t2, t0, t1 | yes |
| 0x0C | 40628E33 | sub t3, t0, t1 | yes |
| 0x10 | 0002BEB7 | lui t4, 0x2B | yes |
| 0x14 | 00000F17 | auipc t5, 0 | yes |
| 0x18 | 10000517 | auipc a0, 0x10000 (first half of `la`) | yes |
| 0x1C | FE850513 | addi a0, a0, -24 (second half of `la`) | yes |
| 0x20 | 00052583 | lw a1, 0(a0) | yes |
| 0x24 | 00752223 | sw t2, 4(a0) | yes |
| 0x28 | 00628463 | beq t0, t1, skip | yes (not taken) |
| 0x2C | 00629463 | bne t0, t1, target | yes (taken) |
| 0x30 | 06300613 | addi a2, zero, 99 (`skip`) | **never** |
| 0x34 | 00C000EF | jal ra, report (`target`) | yes |
| 0x38 | 00A00893 | addi a7, zero, 10 | yes |
| 0x3C | 00000073 | ecall | yes |
| 0x40 | 00700613 | addi a2, zero, 7 (`report`) | yes |
| 0x44 | 00008067 | jalr zero, ra, 0 | yes |

Execution order: 0x00, 0x04, ..., 0x2C, 0x34, 0x40, 0x44, 0x38, 0x3C.
That is 17 instructions retired, with only 0x30 skipped.

## Step 3: `add t2, t0, t1` (PC = 0x00000008)

| Element | Port | Value |
|---------|------|-------|
| pc_reg | out | 0x00000008 |
| pc_4 | out | 0x0000000C |
| instr_mem | data_out | 0x006283B3 |
| decode | r1_reg_idx / r2_reg_idx | 5 / 6 |
| decode | wr_reg_idx | 7 |
| control | reg_do_write_ctrl | 1 |
| control | alu_op2_ctrl | 0 (register, not immediate) |
| registerFile | r1_out / r2_out | 12 / 5 |
| alu_op1_src | out | 12 (register) |
| alu_op2_src | out | 5 (register) |
| alu | res | 17 |
| data_mem | wr_en | 0 |
| reg_wr_src | select / out | ALU result / 17 |
| pc_src | select / out | 0 / 0x0000000C |

### Think: why is there a value on `data_mem.addr`?

`data_mem.addr` is wired straight to `alu.res`, so it carries 17 on every
instruction whether or not memory is used. It is harmless because
`data_mem.wr_en` is 0 (nothing is written) and the write-back mux selects the
ALU result, so whatever the memory reads is discarded. The cost is timing:
the clock period is fixed by the slowest instruction (`lw`, which uses fetch,
register read, ALU, memory and write-back in series), so `add` still pays for
the memory stage it does not use.

## Step 4: every instruction class

| Instruction | Format | imm | op1 mux | op2 mux | alu.res | wb mux / pc mux |
|-------------|--------|-----|---------|---------|---------|-----------------|
| addi t0, zero, 12 | I | 12 | reg (x0 = 0) | imm (12) | 12 | ALU res / PC+4 (0x04) |
| add t2, t0, t1 | R | not used | reg (12) | reg (5) | 17 | ALU res / PC+4 (0x0C) |
| lui t4, 0x2B | U | 0x0002B000 | not used | imm | 0x0002B000 | ALU res / PC+4 (0x14) |
| auipc t5, 0x0 | U | 0 | **PC** (0x14) | imm (0) | 0x00000014 | ALU res / PC+4 (0x18) |
| lw a1, 0(a0) | I | 0 | reg (0x10000000) | imm (0) | 0x10000000 | **mem read** (42) / PC+4 (0x24) |
| sw t2, 4(a0) | S | 4 | reg (0x10000000) | imm (4) | 0x10000004 | not written (reg write = 0) / PC+4 (0x28) |
| beq t0, t1, skip | B | 8 | **PC** (0x28) | imm (8) | 0x00000030 | not written / **PC+4** (0x2C), branch res 0 |
| bne t0, t1, target | B | 8 | **PC** (0x2C) | imm (8) | 0x00000034 | not written / **ALU res** (0x34), branch res 1 |
| jal ra, report | J | 12 | **PC** (0x34) | imm (12) | 0x00000040 | **PC+4** (0x38 into ra) / ALU res (0x40) |
| jalr zero, ra, 0 | I | 0 | reg (ra = 0x38) | imm (0) | 0x00000038 | **PC+4** (discarded, rd = x0) / ALU res (0x38) |

Notes on the table:

- Immediates for branches and `jal` are the PC-relative offsets to the label
  (0x30 - 0x28 = 8, 0x34 - 0x2C = 8, 0x40 - 0x34 = 12).
- The ALU computes the branch/jump target in the same cycle that the branch
  unit compares the registers.
- `jalr zero, ra, 0` is the `ret` pseudo-instruction. Its write-back to `x0`
  is ignored by the register file.

## Step 5: statistics

| Quantity | Value |
|----------|-------|
| Instructions listed in the panel | 18 |
| Instructions retired | 17 |
| Cycles | 17 |
| CPI | 1.00 |
| IPC | 1.00 |

The 18th listed instruction (0x30) is never executed, which is why listed and
retired differ by one.
