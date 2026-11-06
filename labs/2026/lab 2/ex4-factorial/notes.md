# Recursive Factorial in RISC-V: Notes

## 1. Problem

Compute `5!` recursively and print the result.

```cpp
int fact(int n) {
    if (n <= 1) return 1;
    return n * fact(n - 1);
}
```

Expected output:

```
5! = 120
```

## 2. Program Structure

| Part | Role |
|------|------|
| `.data` | Holds the string `"5! = "` (`.asciz` adds a null terminator) |
| `main` | Calls `fact(5)`, saves the result, prints message and result, exits |
| `fact` | Recursive function: argument in `a0`, result returned in `a0` |
| `base_case` | Returns 1 when `n <= 1` |
| `done` | Common epilogue: restore `ra`, free the stack frame, return |

## 3. Register Usage

| Register | Purpose |
|----------|---------|
| `a0` | Argument `n` in, return value out; also used for printing |
| `a7` | Environment call number |
| `ra` | Return address, set by `jal` |
| `sp` | Stack pointer |
| `s0` | Holds the result across the print `ecall`s (callee-saved) |
| `t0` | Constant 1 for the base case comparison |
| `t1` | Original `n` reloaded after the recursive call |

## 4. Stack Frame

Each call allocates 8 bytes:

```
        higher addresses
        +----------------+
sp+4 -> | saved ra       |
        +----------------+
sp+0 -> | saved n (a0)   |
        +----------------+
        lower addresses
```

- `ra` must be saved because the inner `jal` overwrites it.
- `n` must be saved because `a0` is overwritten by `n - 1` and by the return value.

## 5. C++ to Assembly Translation

| C++ | RISC-V |
|-----|--------|
| `if (n <= 1)` | `li t0, 1` / `ble a0, t0, base_case` |
| `return 1;` | `li a0, 1` |
| `n - 1` | `addi a0, a0, -1` |
| `fact(n - 1)` | `jal ra, fact` |
| `n * fact(n - 1)` | `lw t1, 0(sp)` / `mul a0, t1, a0` |
| function return | `lw ra, 4(sp)` / `addi sp, sp, 8` / `jr ra` |

## 6. Function Flow

1. **Prologue:** `addi sp, sp, -8`, then save `ra` and `a0`.
2. **Test:** if `n <= 1`, jump to `base_case`.
3. **Recurse:** set `a0 = n - 1` and `jal fact`.
4. **Combine:** reload `n` from the stack and multiply with the returned value.
5. **Epilogue:** restore `ra`, pop the frame, `jr ra`.

## 7. Call Trace for `fact(5)`

Calls going down (each pushes a frame):

| Call | `n` | Action |
|------|-----|--------|
| fact(5) | 5 | recurse with 4 |
| fact(4) | 4 | recurse with 3 |
| fact(3) | 3 | recurse with 2 |
| fact(2) | 2 | recurse with 1 |
| fact(1) | 1 | base case, return 1 |

Returns coming back up (each pops a frame):

| Call | Computation | Returns |
|------|-------------|---------|
| fact(1) | base case | 1 |
| fact(2) | 2 * 1 | 2 |
| fact(3) | 3 * 2 | 6 |
| fact(4) | 4 * 6 | 24 |
| fact(5) | 5 * 24 | 120 |

Maximum stack depth: 5 frames, 40 bytes.

## 8. Key Concepts

- **Recursion needs a stack:** every active call keeps its own `ra` and `n` in its own frame.
- **Base case first:** the `ble` check stops the recursion; without it the stack would overflow.
- **Multiply after returning:** `mul` runs on the way back up, so the product builds from `1 * 2 * 3 * 4 * 5`.
- **Why `s0` in main:** `a0` is reused for `ecall` arguments, so the result is parked in `s0`.
- **Both paths reach `done`:** the base case falls through into `done`, and the recursive case jumps there with `j done`.

## 9. Environment Calls (Ripes / RARS)

| `a7` | Action | Argument |
|------|--------|----------|
| 1 | Print integer | `a0` = value |
| 4 | Print string | `a0` = address of string |
| 10 | Exit program | none |

## 10. Limitations

- `n` values of 0 or negative return 1 (the `n <= 1` check).
- 32-bit `int` overflows for `n > 12` (`13!` exceeds 2^31 - 1).
- `mul` needs the M extension; Ripes and RARS support it by default.
