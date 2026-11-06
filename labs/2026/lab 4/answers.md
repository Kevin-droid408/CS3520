# Answers

## Part A

**Step 1(e).** The speedup is 4, not 5, because the five stages are unbalanced (200, 100, 200, 200, 100 ps) and the clock must fit the slowest one; five equal 160 ps stages would give 5. Speeding up a single stage does not shorten the clock: IF, EX and MEM are all 200 ps, so all three would have to improve before the period drops; speeding up ID or WB does nothing.

## Step 4 Think
5S-U and 5S-F are identical on p1 because p1 has no dependences and no branches: the forwarding and hazard-detection units never fire, so the hardware they add is idle. Pipelining did not make p1 slower: SC takes 8 × 800 = 6,400 ps, 5S-F takes 12 × 200 = 2,400 ps (2.67× faster). CPI is cycles per instruction, but each pipelined cycle is four times shorter, so the lower-CPI machine can still lose.

## Part C

**Step 5 dependence table**

| Consumer | Register | Producer | Distance | Hazard on 5S-U? | How 5S-F resolves it |
|---|---|---|---|---|---|
| I3 add | t1 | I2 | 1 | yes | EX/MEM → EX |
| I3 add | t0 | I1 | 2 | yes | MEM/WB → EX |
| I4 sub | t2 | I3 | 1 | yes | EX/MEM → EX |
| I4 sub | t0 | I1 | 3 | no | register file (no forwarding needed) |
| I5 slli | t2 | I3 | 2 | yes | MEM/WB → EX |
| I6 add | t3 | I4 | 2 | yes | MEM/WB → EX |
| I6 add | t4 | I5 | 1 | yes | EX/MEM → EX |

**Step 5(c).** Without forwarding, distances 1 and 2 are hazards; 3 or more is safe (see `diagrams/pipeline-diagrams.md`).

**Step 6(c).** The negative value is t3 = −7. `sub t3, t2, t0` reads t2 at distance 1 (too early: still 0) but t0 at distance 3 (I1's write happens in the first half of the cycle in which I4 is in ID, so it is already 7). 0 − 7 = −7. The other three wrong values are 0 because every register they read was read too early and held its initial 0.

**Step 7(a), minimum.** The three adjacent dependences I2→I3, I3→I4 and I5→I6 are each at distance 1 and need two instructions between them, so 3 × 2 = 6. No nop can serve two of them (they sit in different gaps), and removing any one leaves a pair at distance 2, which reads a stale value. The other dependences (I1→I3, I3→I5, I4→I6) are covered by those nops: they end up at distance ≥ 3.
Result: 6 nops, 16 cycles, 12 instructions retired, CPI 1.33.

**Step 7(b).** On 5S-F p2-nops takes 16 cycles; the nops now do nothing useful, they just occupy six pipeline slots.

**Step 7(c).** The nops count as instructions, so IC doubles (6 → 12) and the CPI falls (1.33 vs 1.67) while the cycle count rises (16 vs 10). CPI alone is meaningless across different programs; compare CPU time = IC × CPI × Tc (here 3,200 ps vs 2,000 ps).

**Step 8(a).** 5S-noFW takes 16 cycles on the original p2, the same as p2-nops on 5S-U. The hazard detection unit inserted six bubbles (stalls) automatically, exactly where I inserted nops by hand (2 + 2 + 2).

**Step 8(b).** See the last column of the Step 5 table.

**Step 8 Think.** The ISA must give the same results on every implementation. p2-nops.s hard-codes the spacing for a five-stage pipeline; on a seven-stage pipeline the distance needed would be larger, and the program would silently produce wrong values. With hardware interlocks and forwarding, old binaries stay correct on any pipeline depth; the compiler still schedules for speed, but correctness never depends on it.

## Part D

**Step 9.** See the diagram; cycles = 8 + 4 + 2 = 14. In cycle 5 `add` is held in ID (waiting for `lw t1`), and `lw t3` behind it is held in IF.

**Step 11(a).** t2 = **0x1000000C**. It is 8 (x, correctly forwarded from MEM/WB for t0) + 0x10000004 (the *address* of y, 0x10000000 + 4). (b) The wrong operand came by the EX/MEM → EX path: `lw t1` was in MEM, and its EX/MEM register holds the effective address (ALU result), not the data. The forwarding unit compares register numbers only (EX/MEM.rd = t1 = ID/EX.rs2) and cannot know the data has not been read yet. (c) "…whether the value being forwarded actually exists yet, and if it does not, makes the pipeline wait one cycle (inserts a bubble)."

**Step 12(a).** p3-scheduled: 12 cycles on 5S-F, speedup 14 / 12 = 1.17.
**(b)** On 5S-U t2 = 11 is correct: `lw t0` is 4 back and `lw t1` is 3 back. t5 = 5 is wrong: `lw t3` is 3 back (fine) but `lw t4` is only 2 back, so t4 is read as 0 and t5 = 5 − 0. Also `sw t2` reads t2 at distance 2 and `sw t5` reads t5 at distance 2, so both stores write 0.
**(c)** Four loaded values are live at once, instead of two at a time. On a machine with few registers the compiler would run out and have to spill to memory, adding loads and stores.

## Part E

**Step 13(a).** The first time `bne` is taken it is in EX in cycle 7. `addi t2, zero, 1` (in ID) and `add t3, t1, zero` (in IF) had already entered the pipeline behind it; both are flushed (turned into bubbles). **(b)** 2 cycles per taken branch, so the branch is decided in EX. **(c)** Decided in ID the penalty would be 1 cycle; ID would need a comparator (equality) and a target adder, plus forwarding paths and stall logic for the branch's operands. **(d)** `addi t0` is an ALU instruction at distance 1; its result is forwarded EX/MEM → EX into the branch, so no stall.

**Step 14(a).** SC: cycles = 3n + 4 (a = 3 instructions per iteration, b = 4 instructions outside the loop). 5S-F: cycles = 5n + 6 (a = 3 instructions + 2 flush cycles, since every taken iteration pays the 2-cycle penalty; b = 4 outside instructions + 4 fill cycles − 2 for the final not-taken branch). **(b)** n = 100 → 5 × 100 + 6 = **506** cycles (measured 506). **(c)** CPI → 5/3 ≈ 1.67. The fill cost (4 cycles) is paid once and is amortised away; the taken-branch penalty is paid on every iteration, so it never goes away.

**Step 15 ★.** On 5S-U `bne` reads t0 at distance 1, so it sees the value *before* the latest decrement: the loop only stops when the stale value reaches 0, one iteration late. The body ran 6 times, not 5 (22 instructions retired vs 19), leaving t0 = −1. The sum is 10, not 15: in the first iteration `add t1, t1, t0` reads t0 at distance 2 (still 0), so it adds 0 instead of 5; later iterations add 4, 3, 2, 1, and the extra sixth adds 0. 0 + 4 + 3 + 2 + 1 + 0 = 10.

## Part F

**Step 16.** IC = 44, load-use stalls = 8, taken branches = 7. 5S-F: 44 + 4 + 8 + 14 = 70. SC: 44.

**Step 17(a).** Predictions confirmed: 70 and 44. **(b)** 5S-U executed 49 instructions (not 44) and ended with t1 = −1 and t0 = 0x10000024: the loop ran 9 times. `bne` read a stale t1 (distance 1), so it ran one iteration late; and `add t2, t2, t3` read a stale t3 (distance 1), so each add used the *previous* iteration's element (the first added 0, the ninth added arr[7]). The two bugs cancel: all eight elements are added exactly once, so the total is 31. **(c)** Checking only the final output can hide wrong behaviour; two errors can cancel. Test intermediate state (registers, instruction counts), vary the inputs (different n and data) and test edge cases.

**Step 18(a).** SC = 44 × 800 = 35,200 ps; 5S-F = 70 × 200 = 14,000 ps; speedup 2.51.
**(b)** Time = IC × CPI × Tc. Both run the same IC, so speedup = (IC × CPI_SC × Tc_SC) / (IC × CPI_5S × Tc_5S) = (CPI_SC × Tc_SC) / (CPI_5S × Tc_5S) = (1.00 × 800) / (1.59 × 200) = 2.51.
**(c)** Ideal 5. Unbalanced stages: 800 / 200 = 4, a loss of 1.0 (factor 0.80). CPI above 1: 1 / 1.59 = 0.63, taking 4 down to 2.51, a loss of 1.49. The CPI shortfall costs more. The compiler can only change the CPI term (scheduling away load-use stalls, unrolling to remove branches); stage balance is a hardware design decision.

**Step 19(a).** p5-scheduled: 62 cycles on 5S-F (44 + 4 + 14), speedup 35,200 / 12,400 = 2.84.
**(b)** p5-unrolled: 32 cycles on SC, 42 on 5S-F (3.05× faster). Unrolling removes loop-overhead instructions and so helps both (SC 44 → 32, saving 12 cycles), but on the pipeline it also removes taken branches: 4 fewer × 2-cycle flush = 8 more cycles saved. 5S-F goes 62 → 42, saving 20 cycles.
**(c) ★** `p5-challenge.s`: software-pipelined loop in which every register is read ≥ 3 instructions after being written. Correct (total = 31) on 5S-U in 69 cycles, exactly the same as 5S-F, because it never triggers a stall or a forward. It shows 5S-F's forwarding/hazard hardware sits idle on carefully scheduled code, yet it is still worth having: it guarantees correctness for all code (unscheduled code, code scheduled for a different pipeline) and costs nothing in cycles when unused.

## Tutorial problems

**T1.** (a) SC: 250 + 175 + 225 + 300 + 150 = 1,100 ps. Five-stage: slowest stage 300 + 25 = 325 ps. (b) Latency: SC 1,100 ps; pipeline 5 × 325 = 1,625 ps. It is longer because every instruction takes five slow cycles and pays the register overhead; no contradiction, because throughput (one instruction per 325 ps) is what improves. (c) SC: 10⁶ × 1,100 = 1.1 ms. Pipeline: (10⁶ + 4) × 325 = 325,001,300 ps ≈ 0.325 ms. Speedup 1,100/325 = 3.38. (d) New stages (+25): 275, 200, 250, 175, 175, 175 → clock 275 ps. Time = (10⁶ + 5) × 275 ≈ 0.275 ms; speedup 1,100/275 = 4.00. The load-use hazard becomes more expensive: the loaded value is ready only at the end of the second MEM stage, so the stall grows from 1 to 2 cycles.

**T2.** (a) RAW dependences: I2←I1 (s0, d1); I3←I2 (s1, d1); I4←I1 (s0, d3); I4←I3 (s2, d1); I5←I1 (s0, d4); I5←I3 (s2, d2). (t2 in I3 has no producer; it is 0.) (b) See `diagrams/pipeline-diagrams.md`: one stall cycle, `sub` held in ID in cycle 5. (c) I2←I1 forwarded EX/MEM → EX. I3←I2: stalled one cycle, then forwarded MEM/WB → EX. I4←I3 (s2): EX/MEM → EX. I5←I3 (s2): MEM/WB → EX. I4←I1 and I5←I1 (s0): read from the register file. (d) 5 + 4 + 1 = **10 cycles**. (e) No: `lw` depends on `addi`, `sub` on `lw`, and both `sw` and `or` on `sub`, so nothing independent exists to put between `lw` and `sub`.

**T3.** (a) See the table in `results.md`. (b) An ALU result exists at the end of EX, so it can be forwarded straight into the next instruction's EX; a loaded value only exists at the end of MEM, one stage later, so the next instruction must wait one cycle. (c) The forwarding unit would happily forward the load's address, as in Step 11, giving silent wrong results; hazard detection is needed to stall and let the loaded data arrive.

**T4.** With a BTB and "backward taken", only the final loop exit is mispredicted: cycles = IC + 4 + 2 = (3n + 4) + 6 = 3n + 10. (a) n = 5: 25 cycles (speedup 31/25 = 1.24); n = 20: 70 cycles (106/70 = 1.51). (b) 3n + 10; CPI → 1 as n grows. (c) Backward-taken is a poor guess for forward branches that skip code (e.g. `beq t0, zero, done`) and for loops that run very few times.

**T5.** (a) CPI = 1 + 0.25 × 0.4 × 1 + 0.15 × 0.6 × 2 = 1 + 0.10 + 0.18 = **1.28**. (b) Speedup = 800 / (1.28 × 200) = **3.13**. (c) Load-use stalls drop to 0.025: CPI = 1.205; speedup = 800 / (1.205 × 200) = **3.32**. (d) Eliminating every load-use stall gives CPI 1.18; halving the branch penalty (2 → 1) gives 1.19. Load-use elimination is lower, but only just. Weigh also: whether any compiler can actually remove *every* load-use stall; the branch change needs extra hardware in ID that may lengthen the clock and creates new stalls; area, power and design effort.

**T6.** (a) Original p5 on the proposed design: each iteration has the load-use stall (1) and a branch stall (1, since `addi t1` is immediately before `bne`), and each taken branch costs 1: cycles = 44 + 4 + 8 + 8 + 7 = **71**, one more than the measured 70, so it is slightly worse: the saved cycle per taken branch (7) is more than eaten by the new stalls (8). (b) p5-scheduled has `add t2` between `addi t1` and `bne`, so there is no branch stall and no load-use stall: 44 + 4 + 7 = **55** cycles. (c) With ID = 180 ps, ID is still shorter than the 200 ps stages, so the clock stays at 200 ps. If ID grows to 240 ps the clock becomes 240 ps: 55 × 240 = 13,200 ps vs 62 × 200 = 12,400 ps for the current design, so the proposal no longer pays off (break-even ID ≈ 225 ps). (d) Recommendation: adopt it only if ID can be kept at or below about 200 ps; with ID = 180 ps the scheduled p5 runs in 11,000 ps vs 12,400 ps (11% faster), but on unscheduled code (71 vs 70 cycles) it is no better, so it depends on a compiler that avoids putting the counter update right before the branch.
