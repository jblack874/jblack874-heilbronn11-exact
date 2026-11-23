/-!
# Heilbronn problem in a triangle, n = 11: definitions

All coordinates are integers: a point `(X, Y)` stands for `(X / 2^D, Y / 2^D)` (see `Heil11.Data`).
The domain is the closed equilateral triangle with vertices `(0, 0)`, `(1, 0)`, `(1/2, √3/2)`,
i.e. after scaling by `S = 2^D`: `(0, 0)`, `(S, 0)`, `(S/2, √3·S/2)`.

Containment is stated without square roots. For `x ≥ 0` and `y ≥ 0`,
`y ≤ √3·x ↔ y² ≤ 3x²` (both sides nonnegative), and likewise for the right edge with `S - x`.
This one equivalence is the only step not formalized here (core Lean has no real numbers).
-/
namespace Heil11

/-- Twice the signed area of the triangle `p q r` (the 2×2 determinant). -/
def det2 (p q r : Int × Int) : Int :=
  (q.1 - p.1) * (r.2 - p.2) - (r.1 - p.1) * (q.2 - p.2)

/-- `p` lies in the closed triangle `(0,0), (S,0), (S/2, √3·S/2)`, in squared form. -/
def InTri (S : Int) (p : Int × Int) : Prop :=
  0 ≤ p.2 ∧ 0 ≤ p.1 ∧ p.2 * p.2 ≤ 3 * (p.1 * p.1) ∧
    0 ≤ S - p.1 ∧ p.2 * p.2 ≤ 3 * ((S - p.1) * (S - p.1))

instance (S : Int) (p : Int × Int) : Decidable (InTri S p) := by
  unfold InTri; infer_instance

/-- The `i`-th point of a configuration (0-indexed). -/
def pt (L : List (Int × Int)) (i : Nat) : Int × Int := L.getD i (0, 0)

end Heil11
