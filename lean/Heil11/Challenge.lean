import Heil11.Defs
import Heil11.Data
/-!
# Challenge statements (no proofs)

`Heil11/Solution.lean` proves each of these theorems under the same name; `lake comparator`
(config `comparator.json`) checks that the statements match and that only the standard axioms are used.

Meaning, with `S = 2^D` and points `pt L i` read as `(X/S, Y/S)`:
* the minimum triangle area of a configuration is `N / (2 · 4^D)`; its normalized score is that area
  divided by the triangle's area `√3/4`.
-/
namespace Heil11

/-- Both configurations have 11 points. -/
theorem lengths : recordPts.length = 11 ∧ fixedPts.length = 11 := by sorry

/-- The published record's point 8 is outside the triangle (it violates `y² ≤ 3x²`, the left edge). -/
theorem record_point8_outside :
    ¬ InTri (2 ^ D) (pt recordPts 8) ∧ 3 * ((pt recordPts 8).1 * (pt recordPts 8).1) < (pt recordPts 8).2 * (pt recordPts 8).2 := by sorry

/-- Every other point of the record is inside. -/
theorem record_others_inside : ∀ i : Fin 11, i.val ≠ 8 → InTri (2 ^ D) (pt recordPts i.val) := by sorry

/-- The fixed configuration equals the record except point 8, whose x moves by one float64 ulp
(`2^-54`, i.e. `8` in units of `2^-57`). -/
theorem fixed_vs_record :
    (∀ i : Fin 11, i.val ≠ 8 → pt fixedPts i.val = pt recordPts i.val) ∧
    (pt fixedPts 8).1 = (pt recordPts 8).1 + 8 ∧ (pt fixedPts 8).2 = (pt recordPts 8).2 := by sorry

/-- Every point of the fixed configuration is inside the triangle. -/
theorem fixed_inside : ∀ i : Fin 11, InTri (2 ^ D) (pt fixedPts i.val) := by sorry

/-- Every triangle of the fixed configuration has twice-area at least `N` (in units of `4^-D`)... -/
theorem fixed_min : ∀ i j k : Fin 11, i < j → j < k →
    N ≤ (det2 (pt fixedPts i.val) (pt fixedPts j.val) (pt fixedPts k.val)).natAbs := by sorry

/-- ...and the triangle (1, 3, 7) attains it, so the minimum is exactly `N`. -/
theorem fixed_min_attained : (det2 (pt fixedPts 1) (pt fixedPts 3) (pt fixedPts 7)).natAbs = N := by sorry

/-- The record has the same minimum `N`, attained by the same triangle (the fix leaves the score unchanged). -/
theorem record_min : (∀ i j k : Fin 11, i < j → j < k →
    N ≤ (det2 (pt recordPts i.val) (pt recordPts j.val) (pt recordPts k.val)).natAbs) ∧
    (det2 (pt recordPts 1) (pt recordPts 3) (pt recordPts 7)).natAbs = N := by sorry

end Heil11
