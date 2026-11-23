# Heilbronn triangles, n = 11: the published record is outside the triangle in exact arithmetic (one-ulp fix, same score)

The n = 11 Heilbronn configuration for the unit equilateral triangle, published by AlphaEvolve
(google-deepmind/alphaevolve_results, `mathematical_results.ipynb`; problem 48 of
google-deepmind/alphaevolve_repository_of_problems; paper arXiv:2511.02864, Section 6.29) and holding the EinsteinArena
leaderboard (solution id 630, score 0.036529889880030156; Euclid 678, CHRONOS 1157 and alpha_omega_agents 1425 tie with the
same coordinates), has point 8 =
(0.3612735110422483, 0.6257440765539699). Read as exact binary rationals, that point lies 1.848e-17 outside the left
edge y <= sqrt(3)·x. Float64 checks (`y > sq3 * x`) accept it.

**Fix.** Moving point 8 inward by one float64 ulp in x (0.3612735110422483 -> 0.36127351104224836) gives a configuration
that is exactly inside the triangle with the identical exact score, because the smallest triangle (points 1, 3, 7) does
not use point 8:

- min area = 10266408159649983504586961999535 / 649037107316853453566312041152512
- score = 0.036529889880030128856927016286869953...

The record value stands; only the coordinate file needs the one-ulp change.

**Better replacement already exists.** The canonical Heilbronn table (math.tejstead.com/heilbronn/triangle/, linked from
Friedman's index) publishes an exact solve of the same configuration's tie system (17 tied minimal triangles), as
30-decimal literals in the triangle (0,0),(1,0),(0,1). Checked here in exact rationals: all 11 points inside, min
normalized area 0.036529889880030216424847127960782…, which is 8.76e-17 above the float64 configuration. The one-ulp fix
is the minimal float64 change; the tie-system coordinates are the better replacement. Credit for that solve: the
math.tejstead.com table. (`tejstead_n11_points.txt`, `tejstead_exact_check.txt`.)

## Files

| File | What it is |
|---|---|
| `heil_exact.py` | Exact check and fix, Python standard library only |
| `heil_exact_output.txt` | Output of `python3 heil_exact.py record_heil11.json` |
| `arena_verifier_output.txt` | The arena verifier's float64 logic run on both configurations |
| `record_heil11.json` | The record as served by EinsteinArena (`/api/solutions/best?problem_id=15`) |
| `heil11_exact_valid.json` | The fixed configuration |
| `tejstead_n11_points.txt`, `tejstead_exact_check.txt` | The canonical table's exact-solve coordinates and our exact check of them |
| `4_heilbronn11.png` | Plot of the configuration, point 8 and the minimum triangle |

## Reproduce

```
python3 heil_exact.py record_heil11.json
```

Containment is decided in rationals: with x, y >= 0, a point is inside iff y² <= 3x² and y² <= 3(1−x)² (and y >= 0).
Triangle areas are exact rationals; the score divides by the triangle's area sqrt(3)/4, evaluated to 60 digits.

Suggested verifier change: decide containment exactly as above instead of in float64.

## Credit and notes

Configuration: AlphaEvolve (Google DeepMind). This repo only checks it and proposes the one-ulp fix.
Found with AI assistance (Claude, Anthropic); Joe Black takes responsibility for the report.
