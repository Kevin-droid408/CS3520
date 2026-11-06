# Iterative GCD in RISC-V: Notes

## 1. Problem

Compute the greatest common divisor of `48` and `18` using the Euclidean algorithm, then print it.

```cpp
int GCD(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}
```

Expected output:

```
GCD: 6
```

## 2. Euclidean Algorithm

The GCD does not change when the larger number is replaced by its remainder after division by the smaller one:

`gcd(a, b) = gcd(b, a mod b)`

Repeat until `b` is 0. The answer is then `a`.

Time complexity: O(log(min(a, b))). Space complexity: O(1).

## 3. Program Structure

| Part | Role |
|------|------|
| `.data` | Holds the string `"GCD: "` (`.asciz` adds a null terminator) |
| `main` | Loads `x` and `y`, calls `GCD`, prints message and result, exits |
| `GCD` / `loop` | Repeats the remainder step while `b != 0` |
| `done` | Returns to the caller with the answer already in `a0` |

## 4. Register Usage

| Register | Purpose |
|----------|---------|
| `a0` | Parameter `a`; also the return value |
| `a1` | Parameter `b` |
| `t0` | Temporary holding the old `b` |
| `s0` | Holds the result across the print `ecall`s |
| `a7` | Environment call number |
| `ra` | Return address, set by `jal` |
| `x0` | Constant zero register |

## 5. C++ to Assembly Translation

| C++ | RISC-V |
|-----|--------|
| `while (b != 0)` | `beq a1, x0, done` at the top of `loop` (exit when `b == 0`) |
| `temp = b;` | `mv t0, a1` |
| `b = a % b;` | `rem a1, a0, a1` |
| `a = temp;` | `mv a0, t0` |
| loop back | `j loop` |
| `return a;` | `jr ra` (`a` is already in `a0`) |
| `GCD(x, y)` | `jal ra, GCD` |

## 6. Trace Table for `GCD(48, 18)`

| Iteration | `a` (before) | `b` (before) | `temp` | `b = a % b` | `a = temp` |
|-----------|--------------|--------------|--------|-------------|------------|
| 1 | 48 | 18 | 18 | 12 | 18 |
| 2 | 18 | 12 | 12 | 6 | 12 |
| 3 | 12 | 6 | 6 | 0 | 6 |
| exit | 6 | 0 | - | - | - |

`b == 0`, so the loop ends and `a = 6` is returned.

## 7. Key Concepts

- **Order matters:** `b` is copied to `t0` before `rem` overwrites `a1`, otherwise the old `b` is lost.
- **`rem` instruction:** computes the signed remainder (`a0 % a1`). It belongs to the M extension, which Ripes and RARS support.
- **Loop condition inverted:** C++ loops while `b != 0`; assembly exits when `b == 0` with `beq`, falling through into the body otherwise.
- **`x0` register:** always reads as 0, so `beq a1, x0, done` tests `b == 0` without loading a constant.
- **Leaf function:** `GCD` makes no calls, so it needs no stack frame and does not save `ra`.
- **Return value convention:** the result is left in `a0`, which is why `done` is only `jr ra`.
- **Why `s0` in main:** `a0` is reused for `ecall` arguments, so the result is parked in `s0`.

## 8. Environment Calls (Ripes / RARS)

| `a7` | Action | Argument |
|------|--------|----------|
| 1 | Print integer | `a0` = value |
| 4 | Print string | `a0` = address of string |
| 10 | Exit program | none |

## 9. Limitations and Edge Cases

- `GCD(a, 0)` returns `a` immediately (loop never runs).
- `GCD(0, b)` returns `b` after one iteration (`0 % b = 0`).
- Negative inputs give a result that can be negative, because `rem` keeps the sign of the dividend.
- If both inputs are 0, the result is 0.
