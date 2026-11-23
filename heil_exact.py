"""Exact containment + score check for the EinsteinArena Heilbronn (triangles, n = 11) record, and an exactly valid
nearest configuration. Standard library only.

Containment (triangle A=(0,0), B=(1,0), C=(1/2, sqrt3/2)): y >= 0, y <= sqrt3*x, y <= sqrt3*(1-x).
With x, y read as the exact binary rationals of their float64 values, these are decided exactly by
  y >= 0,  x >= 0 and y^2 <= 3 x^2,  1 - x >= 0 and y^2 <= 3 (1-x)^2.
Score = min triangle area / (sqrt3/4); areas are exact rationals, the normaliser is evaluated to 60 digits.

Usage: python3 heil_exact.py record.json            (checks the record and builds the fixed configuration)
"""
import json, sys, itertools, math, decimal
from fractions import Fraction as F
decimal.getcontext().prec = 60
R3 = decimal.Decimal(3).sqrt()

def dec(q): return decimal.Decimal(q.numerator) / decimal.Decimal(q.denominator)

def check(points):
    P = [(F(x), F(y)) for x, y in points]
    bad = []
    for i, (x, y) in enumerate(P):
        if y < 0: bad.append((i, "bottom edge y >= 0", float(-y)))
        if not (x >= 0 and y * y <= 3 * x * x): bad.append((i, "left edge y <= sqrt3*x", float(dec(y) - R3 * dec(x))))
        if not (1 - x >= 0 and y * y <= 3 * (1 - x) ** 2): bad.append((i, "right edge y <= sqrt3*(1-x)", float(dec(y) - R3 * dec(1 - x))))
    areas = {}
    for i, j, k in itertools.combinations(range(len(P)), 3):
        (a, b), (c, d), (e, f) = P[i], P[j], P[k]
        areas[(i, j, k)] = abs(a * (d - f) + c * (f - b) + e * (b - d)) / 2
    m = min(areas.values()); argmin = [t for t, v in areas.items() if v == m]
    score = dec(m) / (R3 / 4)
    return bad, m, score, argmin

rec = json.load(open(sys.argv[1]))["points"]
bad, m, score, argmin = check(rec)
print("RECORD (EinsteinArena heilbronn-triangles, AlphaEvolve, 0.036529889880030156)")
print("  containment violations:", bad if bad else "none")
print("  exact min area:", f"{m.numerator}/{m.denominator}")
print("  score (60 digits):", score)
print("  min attained by triples:", argmin)

# Nearest exactly valid configuration: move each violating point inward by the fewest float64 ulps.
fixed = [list(p) for p in rec]
for i, edge, amt in bad:
    x, y = fixed[i]
    for k in range(1, 10000):
        if "left" in edge:  xx = x; [xx := math.nextafter(xx, math.inf) for _ in range(k)]; cand = [xx, y]    # x up = inward
        elif "right" in edge: xx = x; [xx := math.nextafter(xx, -math.inf) for _ in range(k)]; cand = [xx, y] # x down = inward
        else: cand = [x, 0.0]
        test = [list(p) for p in fixed]; test[i] = cand
        if not any(t[0] == i for t in check(test)[0]):
            fixed = test; print(f"  point {i}: moved inward by {k} ulp(s) in x: {rec[i]} -> {cand}"); break
bad2, m2, score2, argmin2 = check(fixed)
print("FIXED (nearest exactly valid)")
print("  containment violations:", bad2 if bad2 else "none")
print("  exact min area:", f"{m2.numerator}/{m2.denominator}")
print("  score (60 digits):", score2)
print("  float64 score:", float(score2))
print("  change vs record:", score2 - score, f"(relative {(score2 - score) / score:.3e})")
print("  min attained by triples:", argmin2)
json.dump({"points": fixed, "note": "EinsteinArena heilbronn-triangles record (AlphaEvolve) with violating point(s) moved inside by the fewest float64 ulps; exactly inside the triangle"}, open("heil11_exact_valid.json", "w"))
