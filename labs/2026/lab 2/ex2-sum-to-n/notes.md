# notes.md — Sum Program (RISC-V)

## What it does
Computes the sum of all elements in a 7-element integer array (`12, 45, 7, 93, 28, 61, 4`)
by calling a `Sum(array, size)` function, then prints the result with the label
"Sum of N integers: ".

## Register usage

**`main`**
- `a0` — array base address (`&array[0]`), then holds `Sum`'s return value after the call
- `a1` — array size (7)
- `s0` — saved copy of the sum returned by `Sum`
- `ra` — saved/restored on the stack around the `Sum` call (needed since `main` itself was `jal`-ed into, though here it's mostly precautionary)

**`Sum`**
- `a0` / `s0` — array base address (copied into `s0` so `a0` is free for the return value)
- `a1` / `s1` — array size (copied into `s1`)
- `s2` — running sum (accumulator, returned in `a0` at the end)
- `s3` — loop index `i`
- `t0` — scratch: `i*4` offset, then `&array[i]`
- `t1` — scratch: `array[i]` value loaded from memory

`s0`–`s3` are callee-saved, so `Sum` saves them to the stack on entry and restores
them before returning — standard practice since these registers must look
unchanged to the caller.

## What was harder than expected
- Getting the **byte offset** right: `array[i]` isn't at `base + i`, it's at
  `base + i*4` (word = 4 bytes), so the `slli t0, s3, 2` shift-left-by-2 step is
  easy to forget and was the main thing to double-check.
- Making sure **`s`-registers were saved/restored symmetrically** (push order vs.
  pop order) — the code saves `s0,s1,s2,s3` and restores them in the same order,
  which is correct since they're at fixed, distinct stack offsets (not a true
  stack discipline where order would matter).
