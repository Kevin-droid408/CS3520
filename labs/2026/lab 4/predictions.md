# Predictions (commit this file BEFORE running the programs in Ripes)

## Step 2 / Step 4 — p1-independent.s
8 instructions, no dependences, no branches. Pipelined cycles = 8 + 4 = 12; CPI = 1.50 on 5S-U and 5S-F (identical, nothing to protect). SC: 8 cycles, CPI 1.00.

## Step 6a — p2-dependent.s on 5S-U
A consumer less than 3 instructions after its producer reads the old value, which is 0 for every register used here.
- I3 `add t2,t0,t1`: t0 is distance 2, t1 distance 1 → both stale (0) → **t2 = 0**
- I4 `sub t3,t2,t0`: t2 stale (0, distance 1), t0 is distance 3 so correct (7) → 0 − 7 = **t3 = −7**
- I5 `slli t4,t2,1`: t2 stale (distance 2) → 0 << 1 = **t4 = 0**
- I6 `add t5,t3,t4`: t3 (distance 2) and t4 (distance 1) both stale → **t5 = 0**

## Step 9 — p3-loaduse.s on 5S-F
Two load-use pairs: `lw t1` → `add t2` and `lw t4` → `sub t5`. One stall each. Cycles = 8 + 4 + 2 = **14**.

## Step 16 — p5-arraysum.s
IC = 3 + 8 × 5 + 1 = 44. Load-use stalls = 8 (one per iteration: `lw t3` → `add t2,t2,t3`). Taken branches = 7 (8 iterations, last one falls through).
5S-F cycles = 44 + 4 + 8 + 2 × 7 = **70**. SC cycles = **44**.
