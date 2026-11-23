# Lean 4 formalization (added 23 Nov 2026; the Python checks are unchanged)

Follows the checking conventions used for the Lean proof of the Riemann Hypothesis released 20 Nov 2026:
statements in a separate challenge file, proofs in a solution file, `lake comparator` to confirm the two state
the same theorems with no axioms beyond the standard three, and the exported proof replayed by every external
kernel bundled with Lean (`--paranoid`).

| File | Contents |
|---|---|
| `Heil11/Defs.lean` | `det2` (twice the signed area), `InTri` (closed triangle (0,0),(1,0),(1/2,√3/2) in squared form), `pt` |
| `Heil11/Data.lean` | Both configurations as exact integers (float64 coordinate × 2^57) and `N` |
| `Heil11/Challenge.lean` | The 8 theorem statements, each `sorry` |
| `Heil11/Solution.lean` | The same statements, proved by kernel computation (`decide`); no `sorry`, no `native_decide` |
| `comparator.json`, `comparator_output.txt` | Comparator config and its run: Lean default and paranoid kernels, lean4lean, nanoda, con-leche, con-ron all accept |
| `Axioms.lean`, `axioms_output.txt` | `#print axioms` for each theorem: `propext` only (one theorem uses none) |

What is proved (points 0-indexed, coordinates = integer / 2^57):
- `record_point8_outside`: the published record's point 8 violates the left edge (`3x² < y²`).
- `record_others_inside`: the other 10 record points are inside.
- `fixed_vs_record`: the fixed configuration differs only in point 8's x, by 8·2^-57 = one float64 ulp.
- `fixed_inside`: all 11 fixed points are inside.
- `fixed_min`, `fixed_min_attained`: every triangle has |det2| ≥ N, with equality at (1, 3, 7), so the minimum area
  is N / (2·4^57) = 10266408159649983504586961999535/649037107316853453566312041152512.
- `record_min`: the record has the same minimum, so the fix leaves the score unchanged.

Not formalized: the step `y ≤ √3·x ⇔ y² ≤ 3x²` for x, y ≥ 0 (core Lean has no real numbers; Mathlib's prebuilt
cache was not reachable from the build machine), and the division by the triangle's area √3/4 in the normalized score.

Reproduce (Lean v4.36.0-rc1, no dependencies; `bwrap` required for the sandbox):
```
lake build
lake comparator --paranoid
lake env lean Axioms.lean
```
