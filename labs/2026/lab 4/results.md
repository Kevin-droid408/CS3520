# Results (all tables from the handout)

Clock periods from Step 1: SC = 800 ps, five-stage = 200 ps. Hardware numbers were produced by a cycle-accurate model of the Ripes SC / 5S-U / 5S-F / 5S-noFW / 5S-noHD processors (branch resolved in EX, 2-cycle flush, register file written in the first half of a cycle). **Re-check each row in Ripes before you submit.**

## Part A — Step 1
| | Answer |
|---|---|
| (a) SC clock | 200 + 100 + 200 + 200 + 100 = **800 ps**; `lw` uses all five stages |
| (b) Pipelined clock | slowest stage = **200 ps** |
| (c) `lw` latency | SC 800 ps; pipeline 5 × 200 = **1000 ps** |
| (d) 1,000,000 instructions | SC 800,000,000 ps (0.8 ms); pipeline (10⁶ + 4) × 200 = 200,000,800 ps (≈ 0.2 ms); speedup ≈ **4.00** |

## Step 4 — p1-independent.s
| Processor | Cycles | Instrs. retired | CPI | Execution time |
|---|---|---|---|---|
| SC | 8 | 8 | 1.00 | 6,400 ps |
| 5S-U | 12 | 8 | 1.50 | 2,400 ps |
| 5S-F | 12 | 8 | 1.50 | 2,400 ps |

## Step 6 — p2-dependent.s
| Processor | t2 | t3 | t4 | t5 | Cycles | CPI | Correct? |
|---|---|---|---|---|---|---|---|
| SC | 12 | 5 | 24 | 29 | 6 | 1.00 | yes |
| 5S-U | 0 | −7 | 0 | 0 | 10 | 1.67 | **no** |
| 5S-F | 12 | 5 | 24 | 29 | 10 | 1.67 | yes |

## Step 7 / 8 — repairs
| Run | Cycles | Retired | CPI |
|---|---|---|---|
| p2-nops.s on 5S-U (6 nops) | 16 | 12 | 1.33 |
| p2-nops.s on 5S-F | 16 | 12 | 1.33 |
| original p2 on 5S-noFW | **16** | 6 | 2.67 |
| original p2 on 5S-F | 10 | 6 | 1.67 |

## Step 10 — p3-loaduse.s
| Processor | t2 (x + y) | t5 (z − w) | Cycles | CPI | Correct? |
|---|---|---|---|---|---|
| SC | 11 | 3 | 8 | 1.00 | yes |
| 5S-U | 0 | 0 | 12 | 1.50 | no |
| 5S-F | 11 | 3 | 14 | 1.75 | yes |

Step 11: 5S-noHD gives t2 = **1000000C** (and t5 = −268435463).

## Step 12 — p3-scheduled.s
| Run | Cycles | Notes |
|---|---|---|
| 5S-F | 12 | speedup over Step 10 = 14 / 12 = 1.17 |
| 5S-U | 12 | t2 = 11 (correct), t5 = 5 (wrong); `sw` stores 0 and 0 |

## Step 13 / 14 — p4-loop.s
| n | SC cycles | 5S-F cycles | 5S-F CPI |
|---|---|---|---|
| 1 | 7 | 11 | 1.57 |
| 2 | 10 | 16 | 1.60 |
| 5 | 19 | 31 | 1.63 |
| 10 | 34 | 56 | 1.65 |
| 20 | 64 | 106 | 1.66 |
| 100 | 304 | **506** | 1.66 |

Fits: SC cycles = 3n + 4; 5S-F cycles = 5n + 6.

## Step 15 — p4 (n = 5) on 5S-U vs SC
| | t1 (sum) | t0 | Instrs. retired | Loop body runs |
|---|---|---|---|---|
| SC | 15 | 0 | 19 | 5 |
| 5S-U | 10 | −1 | 22 | 6 |

## Step 17 — p5-arraysum.s
| Processor | Cycles | Instrs. retired | CPI | total (t2) | Correct? |
|---|---|---|---|---|---|
| SC | 44 | 44 | 1.00 | 31 | yes |
| 5S-U | 69 | 49 | 1.41 | 31 | right total, **wrong execution** (t1 = −1, t0 = 0x10000024) |
| 5S-F | 70 | 44 | 1.59 | 31 | yes |

## Step 18 — execution time
SC: 44 × 800 = 35,200 ps. 5S-F: 70 × 200 = 14,000 ps. Speedup = **2.51**.

## Step 19
| Program | SC cycles | 5S-F cycles | Time SC | Time 5S-F | Speedup |
|---|---|---|---|---|---|
| p5 original | 44 | 70 | 35,200 ps | 14,000 ps | 2.51 |
| p5-scheduled.s | 44 | 62 | 35,200 ps | 12,400 ps | 2.84 |
| p5-unrolled.s (×2) | 32 | **42** | 25,600 ps | 8,400 ps | 3.05 |
| p5-challenge.s | 49 | 69 | — | — | correct on 5S-U in 69 cycles |

## Tutorial table T3
| Producer | 5S-U (nops) | 5S-noFW (stalls) | 5S-F (stalls) |
|---|---|---|---|
| ALU instruction | 2 | 2 | 0 |
| Load (lw) | 2 | 2 | 1 |

## Google Form answers
| Q | Answer |
|---|---|
| Q1 | 800 |
| Q2 | 81 |
| Q3 | 12 |
| Q4 | -7 |
| Q5 | 6 |
| Q6 | 16 |
| Q7 | 14 |
| Q8 | 1000000C |
| Q9 | 2 |
| Q10 | 506 |
| Q11 | 49 |
| Q12 | 2.51 |
| Q13 | 42 |
