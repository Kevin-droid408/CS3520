# Lab 4 — Pipelining and Performance

CS3520 Computer Organisation and Architecture I · AY 2026/2027 · Supports Weeks 8–9

## What this lab is about

You run the same small RISC-V programs on Ripes' single-cycle processor and its five-stage pipeline variants, then explain every difference you see in cycle count, CPI and correctness. You will break an unprotected pipeline on purpose, repair it with nops and by reordering code, watch forwarding, stalls and branch flushes happen, and finish by measuring how much faster the pipeline really is than the single-cycle processor.

The full instructions are in the Lab 4 handout on Thuto.

## Programs

| File | What it exercises | Used in |
| --- | --- | --- |
| `p1-independent.s` | Eight independent instructions — the pipeline's best case | Part A, Part B |
| `p2-dependent.s` | A chain of read-after-write dependences at distances 1, 2 and 3 | Part C |
| `p3-loaduse.s` | Two load-use hazards, and room to schedule them away | Part D |
| `p4-loop.s` | A counting-down loop: the cost of a taken branch | Part E |
| `p5-arraysum.s` | Loads, a load-use pair and a loop together — the final comparison | Part F |

## How to run

1. In Ripes, choose **Select processor → RISC-V → 32-bit** and the processor named in the handout step. Use the **Standard** layout and RV32I. Leave the register initialisation at its defaults: `p3` and `p5` use `gp` (x3) = `0x10000000`, the first address of `.data`, as their base address.
2. Open the program in the Editor tab (assembly input).
3. **Reset (F3)** before each experiment, then use **Run (F8)** for the Execution info numbers. For the pipeline diagram, reset, step with **Clock (F5)** or **Auto clock (F6)**, then press **Show pipeline diagram**.

None of the programs ends with an `ecall`: each simply runs off its last instruction, which Ripes treats as the end of the program.

## What you submit

Your own work goes in `labs/2026/lab-4/` of your fork — see the handout's *What to Submit* section.

Create `p2-nops.s`, `p3-scheduled.s`, `p5-scheduled.s`, and `p5-unrolled.s` as you complete Steps 7, 12, and 19. These are student exercises derived from the starter programs above. Include your diagrams, results, written answers, and AI-use declaration as specified in the handout, and commit each prediction before running its experiment.
