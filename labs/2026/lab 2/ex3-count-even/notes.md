# notes.md — CountEvens Program (RISC-V)

## What it does
Counts how many elements of a 7-element integer array (`12, 45, 7, 93, 28, 61, 4`)
are even, by calling a `CountEvens(array, size)` function, then prints the result
with the label "Number of even numbers: ".

## Register usage

**`main`**
- `a0` — array base address (`&array[0]`), then holds `CountEvens`'s return value after the call
- `a1` — array size (7)
- `s0` — saved copy of the count returned by `CountEvens`

**`CountEvens`**
- `a0` / `s1` — array base address (copied into `s1` so `a0` is free for the return value)
- `a1` / `s2` — array size (copied into `s2`)
- `t0` — running count of evens (returned in `a0` at the end)
- `t1` — loop index `i`
- `t2` — scratch: `i*4` byte offset
- `t4` — scratch: `&array[i]`
- `t3` — scratch: `array[i]`, then `array[i] % 2`
- `t6` — constant `2`, used as the divisor for the mod check

No `s`-registers besides `s1`/`s2` are used, and since `CountEvens` never calls
another function, `ra` is never clobbered — so no stack frame is needed here.

## What was harder than expected
- The original version accidentally **dereferenced** the array pointer and size
  (`lw s1, 0(a0)` instead of `mv s1, a0`), which silently read garbage memory
  instead of using the address/value already sitting in the register — an easy
  mistake to miss since it doesn't crash outright.
- The loop-exit branch `bge t1, s2, done` is easy to get backwards
  (`bge s2, t1, ...`) — swapping the operands changes "exit when i >= size"
  into "exit almost immediately," so operand order needed double-checking.
- Making sure the `t2 = i*4` offset was actually *used* in the address
  calculation, rather than computed and then ignored.
