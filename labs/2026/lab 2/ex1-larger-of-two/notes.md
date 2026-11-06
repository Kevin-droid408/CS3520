# LargerIntegers: C++ to RISC-V Assembly Notes

## 1. Problem

Find the two largest integers in an array in a single pass.

Array: `{12, 45, 7, 93, 28, 61, 4}`, size 7
Expected output:

```
First larger integer: 93
Second larger integer: 61
```

## 2. Algorithm

1. Compare `arr[0]` and `arr[1]`; the bigger becomes `max1`, the other `max2`.
2. Loop `i` from 2 to `size - 1`:
   - If `arr[i] > max1`: `max2 = max1`, then `max1 = arr[i]`.
   - Else if `arr[i] > max2`: `max2 = arr[i]`.
3. Print `max1` and `max2`.

Time complexity: O(n). Space complexity: O(1).

## 3. Register Mapping

| C++ variable | Register | Notes |
|--------------|----------|-------|
| `arr` (base address) | `a0` | First argument |
| `size` | `a1` | Second argument |
| `arr[0]` | `t0` | Initial comparison |
| `arr[1]` | `t1` | Initial comparison |
| `max1` | `t2` | Largest so far |
| `max2` | `t3` | Second largest so far |
| `i` | `t4` | Loop counter, starts at 2 |
| address of `arr[i]` | `t5` | Computed each iteration |
| `arr[i]` | `t6` | Loaded value |
| return address | `ra` | Set by `jal` |

## 4. C++ to Assembly Translation

| C++ | RISC-V |
|-----|--------|
| `if (arr[0] > arr[1])` | `blt t1, t0, first_bigger` |
| `max1 = arr[1]; max2 = arr[0];` | `mv t2, t1` / `mv t3, t0` |
| `for (i = 2; i < size; i++)` | `li t4, 2` / `bge t4, a1, print` / `addi t4, t4, 1` / `j loop` |
| `arr[i]` | `slli t5, t4, 2` / `add t5, a0, t5` / `lw t6, 0(t5)` |
| `if (arr[i] > max1)` | `ble t6, t2, check_max2` (inverted: skip if `<=`) |
| `else if (arr[i] > max2)` | `ble t6, t3, next` (inverted again) |
| `LargerIntegers(array, n)` | `jal ra, LargerIntegers` |
| `return` | `jr ra` |

## 5. Key Concepts

- **Array indexing:** each `int` is 4 bytes, so the byte offset is `i * 4`. `slli t5, t4, 2` shifts left by 2, which multiplies by 4.
- **Inverted branches:** C++ runs the body when the condition is true. Assembly branches *over* the body, so the condition is flipped (`>` becomes `ble`).
- **Calling convention:** arguments go in `a0`, `a1`; `jal` saves the return address in `ra`; `jr ra` returns.
- **Order matters:** `max2 = max1` must happen before `max1 = arr[i]`, otherwise the old `max1` is lost.
- **Temporaries:** only `t` registers are used, so no stack saving is needed in a leaf function.

## 6. Environment Calls (Ripes / RARS)

| `a7` | Action | Argument |
|------|--------|----------|
| 1 | Print integer | `a0` = value |
| 4 | Print string | `a0` = address of string |
| 10 | Exit program | none |

## 7. Trace Table

| Step | `i` | `arr[i]` | `max1` | `max2` |
|------|-----|----------|--------|--------|
| init | - | - | 45 | 12 |
| 1 | 2 | 7 | 45 | 12 |
| 2 | 3 | 93 | 93 | 45 |
| 3 | 4 | 28 | 93 | 45 |
| 4 | 5 | 61 | 93 | 61 |
| 5 | 6 | 4 | 93 | 61 |

## 8. Limitations

- Assumes `size >= 2`, since it reads `arr[0]` and `arr[1]` unconditionally.
- Duplicates: if the largest value appears twice, `max2` will not equal it (strict `>` comparisons), matching the C++ version.
