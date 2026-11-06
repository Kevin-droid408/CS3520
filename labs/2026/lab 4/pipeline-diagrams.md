# Pipeline diagrams (generated cycle by cycle; ✗ = flushed, – = held in the same stage)

## p1-independent.s on 5S-F (Step 2)

| Instruction \ Cycle | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `addi t0, zero, 10` | IF | ID | EX | MEM | WB |  |  |  |  |  |  |  |  |
| `addi t1, zero, 20` |  | IF | ID | EX | MEM | WB |  |  |  |  |  |  |  |
| `addi t2, zero, 30` |  |  | IF | ID | EX | MEM | WB |  |  |  |  |  |  |
| `addi t3, zero, 40` |  |  |  | IF | ID | EX | MEM | WB |  |  |  |  |  |
| `addi t4, zero, 50` |  |  |  |  | IF | ID | EX | MEM | WB |  |  |  |  |
| `addi t5, zero, 60` |  |  |  |  |  | IF | ID | EX | MEM | WB |  |  |  |
| `addi t6, zero, 70` |  |  |  |  |  |  | IF | ID | EX | MEM | WB |  |  |
| `addi s1, zero, 80` |  |  |  |  |  |  |  | IF | ID | EX | MEM | WB |  |

(a) First instruction finishes (WB) in cycle 5, the last in cycle 12.  
(b) cycles = N + k − 1 = N + 4 for k = 5; CPI = (N+4)/N.  
(c) (N+4)/N < 1.05 ⇔ N > 80, so the smallest N is **81** (N = 80 gives exactly 1.05, not below).  
(d) Vertical line through cycle 5: `addi t0` in WB, `addi t1` in MEM, `addi t2` in EX, `addi t3` in ID, `addi t4` in IF.

## p2-dependent.s drawn as if no instruction ever had to wait (Step 5b)

| Instruction \ Cycle | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| I1 `addi t0, zero, 7` | IF | ID | EX | MEM | WB |  |  |  |  |  |
| I2 `addi t1, zero, 5` |  | IF | ID | EX | MEM | WB |  |  |  |  |
| I3 `add t2, t0, t1` |  |  | IF | ID | EX | MEM | WB |  |  |  |
| I4 `sub t3, t2, t0` |  |  |  | IF | ID | EX | MEM | WB |  |  |
| I5 `slli t4, t2, 1` |  |  |  |  | IF | ID | EX | MEM | WB |  |
| I6 `add t5, t3, t4` |  |  |  |  |  | IF | ID | EX | MEM | WB |

Arrows (producer WB → consumer ID). Register file is written in the first half of a cycle and read in the second half, so an arrow is a hazard only if the producer's WB cycle is **later** than the consumer's ID cycle:

| Consumer | Reg | Producer | Producer WB cycle | Consumer ID cycle | Arrow |
|---|---|---|---|---|---|
| I3 add | t0 | I1 | 5 | 4 | backwards — hazard |
| I3 add | t1 | I2 | 6 | 4 | backwards — hazard |
| I4 sub | t2 | I3 | 7 | 5 | backwards — hazard |
| I4 sub | t0 | I1 | 5 | 5 | same cycle — OK |
| I5 slli | t2 | I3 | 7 | 6 | backwards — hazard |
| I6 add | t3 | I4 | 8 | 7 | backwards — hazard |
| I6 add | t4 | I5 | 9 | 7 | backwards — hazard |

**Rule (Step 5c):** producer i has WB in cycle i+4, consumer j has ID in cycle j+1, so it is a hazard iff i+4 > j+1, i.e. distance j − i ≤ 2. On a pipeline without forwarding, distances **1 and 2** are hazards; distance 3 or more is safe.

## p2-dependent.s actually run on 5S-F (Step 8)

| Instruction \ Cycle | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| `addi t0, zero, 7` | IF | ID | EX | MEM | WB |  |  |  |  |  |
| `addi t1, zero, 5` |  | IF | ID | EX | MEM | WB |  |  |  |  |
| `add t2, t0, t1` |  |  | IF | ID | EX | MEM | WB |  |  |  |
| `sub t3, t2, t0` |  |  |  | IF | ID | EX | MEM | WB |  |  |
| `slli t4, t2, 1` |  |  |  |  | IF | ID | EX | MEM | WB |  |
| `add t5, t3, t4` |  |  |  |  |  | IF | ID | EX | MEM | WB |

No stalls: every hazard is forwarded; 6 + 4 = 10 cycles.

## p3-loaduse.s on 5S-F (Step 9)

| Instruction \ Cycle | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `lw t0, 0(gp)` | IF | ID | EX | MEM | WB |  |  |  |  |  |  |  |  |  |
| `lw t1, 4(gp)` |  | IF | ID | EX | MEM | WB |  |  |  |  |  |  |  |  |
| `add t2, t0, t1` |  |  | IF | ID | – | EX | MEM | WB |  |  |  |  |  |  |
| `lw t3, 8(gp)` |  |  |  | IF | – | ID | EX | MEM | WB |  |  |  |  |  |
| `lw t4, 12(gp)` |  |  |  |  |  | IF | ID | EX | MEM | WB |  |  |  |  |
| `sub t5, t3, t4` |  |  |  |  |  |  | IF | ID | – | EX | MEM | WB |  |  |
| `sw t2, 16(gp)` |  |  |  |  |  |  |  | IF | – | ID | EX | MEM | WB |  |
| `sw t5, 20(gp)` |  |  |  |  |  |  |  |  |  | IF | ID | EX | MEM | WB |

Two load-use stalls (`add` held in ID in cycle 5, `sub` held in ID in cycle 9). cycles = 8 + 4 + 2 = **14**. In cycle 5 `add` is held in ID and `lw t3` (behind it) is held in IF.

## p4-loop.s (n = 5), first iteration, on 5S-F (Step 13)

| Instruction \ Cycle | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `addi t0, zero, 5` | IF | ID | EX | MEM | WB |  |  |  |  |  |  |  |  |  |
| `addi t1, zero, 0` |  | IF | ID | EX | MEM | WB |  |  |  |  |  |  |  |  |
| `add t1, t1, t0` |  |  | IF | ID | EX | MEM | WB |  |  |  |  |  |  |  |
| `addi t0, t0, -1` |  |  |  | IF | ID | EX | MEM | WB |  |  |  |  |  |  |
| `bne t0, zero, loop` |  |  |  |  | IF | ID | EX | MEM | WB |  |  |  |  |  |
| `addi t2, zero, 1` |  |  |  |  |  | IF | ID | ✗ | ✗ | ✗ |  |  |  |  |
| `add t3, t1, zero` |  |  |  |  |  |  | IF | ✗ | ✗ | ✗ | ✗ |  |  |  |
| `add t1, t1, t0` |  |  |  |  |  |  |  | IF | ID | EX | MEM | WB |  |  |
| `addi t0, t0, -1` |  |  |  |  |  |  |  |  | IF | ID | EX | MEM | WB |  |
| `bne t0, zero, loop` |  |  |  |  |  |  |  |  |  | IF | ID | EX | MEM | WB |
| `addi t2, zero, 1` |  |  |  |  |  |  |  |  |  |  | IF | ID | ✗ | ✗ |
| `add t3, t1, zero` |  |  |  |  |  |  |  |  |  |  |  | IF | ✗ | ✗ |
| `add t1, t1, t0` |  |  |  |  |  |  |  |  |  |  |  |  | IF | ID |
| `addi t0, t0, -1` |  |  |  |  |  |  |  |  |  |  |  |  |  | IF |
| `bne t0, zero, loop` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `addi t2, zero, 1` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `add t3, t1, zero` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `add t1, t1, t0` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `addi t0, t0, -1` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `bne t0, zero, loop` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `addi t2, zero, 1` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `add t3, t1, zero` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `add t1, t1, t0` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `addi t0, t0, -1` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `bne t0, zero, loop` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `addi t2, zero, 1` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `add t3, t1, zero` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

`bne` is in EX in cycle 7, finds t0 = 4 ≠ 0 and redirects the PC. `addi t2` (in ID) and `add t3` (in IF) are flushed; the loop body is refetched in cycle 8. Two cycles lost.

## T2 snippet on 5S-F

| Instruction \ Cycle | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| `addi s0, gp, 8` | IF | ID | EX | MEM | WB |  |  |  |  |  |
| `lw s1, 0(s0)` |  | IF | ID | EX | MEM | WB |  |  |  |  |
| `sub s2, s1, t2` |  |  | IF | ID | – | EX | MEM | WB |  |  |
| `sw s2, 4(s0)` |  |  |  | IF | – | ID | EX | MEM | WB |  |
| `or s3, s0, s2` |  |  |  |  |  | IF | ID | EX | MEM | WB |

10 cycles = 5 + 4 + 1 load-use stall.
