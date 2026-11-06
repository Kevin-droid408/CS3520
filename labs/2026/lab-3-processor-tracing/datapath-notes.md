# CS3520 Lab 3, Part A: Datapath Notes

## Step 2 think question: the third write-back input

Write-back element 14 has three inputs: the data memory output (loads), the
ALU result (arithmetic, `lui`, `auipc`), and **PC + 4**. The two-way
MemtoReg of Week 7 has no PC + 4 input. `jal` and `jalr` cannot work without
it: their job is to save the return address (the address of the next
instruction) in `rd`, and only the PC adder produces that value.

## Step 4 questions

### 1. `lui` vs `auipc`

Both are U-type and both use the same 20-bit immediate (shifted left by 12).
The difference is made by the **ALU operand-1 selection** (`alu_op1_src`) and
the ALU operation:

- `auipc` selects the **PC** as operand 1 and adds the immediate, so
  `t5 = 0x14 + 0 = 20`.
- `lui` does not use a register or the PC; the ALU passes the immediate
  through, so `t4 = 0x0002B000`.

### 2. `sw` writes memory but no register

The signal is the register file write enable, **`reg_do_write_ctrl = 0`**.
Meanwhile the memory write enable (`data_mem.wr_en`) is 1. The write-back
multiplexor still selects an input (the ALU result) and still shows a value
on its output, but nothing consumes it because the register file is not
enabled.

### 3. Path from the branch unit to `pc_src`

1. The **branch unit** compares `r1_out` and `r2_out` according to funct3 and
   produces `res` (1 if the condition holds).
2. **`br_and`** (AND gate) combines `res` with the control unit's `branch`
   signal, so a non-branch instruction can never redirect the PC.
3. **`controlflow_or`** (OR gate) combines `br_and` with the `jump` signal
   (`jal`/`jalr`), which always redirects.
4. The output drives **`pc_src.select`**, choosing between PC + 4 (0) and the
   ALU result (1).

For `beq t0, t1` (12 vs 5): `res = 0`, `br_and = 0`, `controlflow_or = 0`,
so the PC takes PC + 4. For `bne t0, t1`: `res = 1`, `br_and = 1`,
`controlflow_or = 1`, so the PC takes the ALU result (the target).

### 4. Where `jal` and `jalr` get the return address

From the **PC + 4 input** of the write-back mux. Neither the ALU nor data
memory can supply it: in a single-cycle machine the ALU is already busy
computing the jump target (PC + imm for `jal`, `rs1` + imm for `jalr`) in the
same cycle, and data memory only returns stored data. The return address is
already available from the `pc_4` adder.

## Step 5 think question: what did the design sacrifice?

CPU time = IC x CPI x Tc. The instruction count is fixed by the ISA and the
program, and CPI is already 1.00 (the best possible). The term sacrificed is
the **clock period Tc**. Every instruction must fit its whole execution
into one cycle, so Tc equals the delay of the slowest instruction, `lw`:
instruction memory + register read + ALU + data memory + register write.
A pipelined design cuts Tc to roughly the delay of its slowest stage. With
typical textbook component delays (about 200 ps for memory/ALU and 100 ps for
the register file) the single-cycle Tc is about 800 ps against about 200 ps
per pipeline stage, so the single-cycle clock is roughly **4 to 5 times
slower**. Substitute the exact delays from the Week 7 worked exercise.

## Step 6: three differences from the textbook figure

### A. No dedicated branch adder: the ALU computes PC + offset

The branch/jump target is computed by the main ALU. `alu_op1_src` selects the
PC and `alu_op2_src` selects the immediate, so `alu.res` is the target and
feeds the PC multiplexor. The implementer gained **less hardware** (one adder
fewer) and a **uniform mechanism**: the same PC + immediate path gives the
target for `beq`/`bne`/..., `jal`, and the result of `auipc`, with no extra
unit. The price is an extra multiplexer on the ALU's first input.

### B. A separate comparison unit instead of the ALU's Zero flag

A Zero flag after subtraction only answers "are they equal?", which is enough
for `beq` and `bne` but not for `blt`, `bge`, `bltu` and `bgeu`. Those need
signed and unsigned less-than, which would require extra flag logic (sign,
overflow, carry) on the ALU. A dedicated comparator evaluates all six branch
conditions directly. The instructions that need it are all six branches:
`beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`. It is also what makes A possible:
because the comparison no longer uses the ALU, the ALU is free to compute the
target in the same cycle.

### C. Three-input write-back multiplexer

The third input is **PC + 4**. It is required by `jal` and `jalr`, which save
the return address in `rd`. The textbook's two-way mux (ALU result or memory
data) cannot express function calls and returns.

### Think: dedicated adder vs reusing the ALU

- **Dedicated branch adder (textbook).** Trade-off: more hardware, but the
  ALU stays free to do a comparison in parallel, and the ALU inputs need no
  PC multiplexer. Choose it when speed matters, especially in a **pipelined**
  design where computing the target early (in the decode stage) shortens the
  branch penalty.
- **ALU reuse (this implementation).** Trade-off: fewer adders and a
  uniform path for targets and `auipc`, at the cost of extra multiplexers
  and a separate comparator. In a single-cycle design the branch path is not
  the critical path (`lw` is), so the extra mux costs no clock speed. Choose
  it when **area and simplicity** matter, as in a small teaching or embedded
  core.

The fetch datapath still keeps a dedicated PC + 4 adder in both designs
because PC + 4 must be computed every cycle at the same time as the ALU is
busy with the instruction itself.
