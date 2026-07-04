# Hypothesis Frontier

Date: 2026-07-03 (second iteration)

## Lean `sorry` count

`main`: 0. No `axiom` declarations.
Statement-first obligations live on `frontier/M1` under
`LeanTransferMatrix/Frontier/` and are listed below.

## Explicit hypotheses currently carried

`TransferOperatorInterface` still packages, for a GENERIC model:

* `gapToClusteringHypothesis : HasStrictSpectralGap data -> HasExponentialClustering data`
* `clusteringToGapHypothesis : HasUniformExponentialClustering data -> HasStrictSpectralGap data`

NEW: on the ferromagnetic zero-field Ising chain (`0 ≤ β`) both hypotheses
are now THEOREMS, and `Ising1D.isingInterface` is the first fully
unconditional instance of the interface. The generic hypotheses remain only
for models whose Perron-Frobenius input has not been proved.

## Closed facts on `main`

M0 layer (previous iteration): eigenvectors and eigenvalues of the symmetric
2x2 transfer matrix; correlation as spectral-ratio power.

Quantitative gap layer (`Ising1DGap.lean`):

* `isingLambdaPlus_pos`, `isingLambdaMinus_nonneg`,
  `isingLambdaMinus_lt_isingLambdaPlus`, `abs_isingLambdaMinus_lt`:
  the two-sided strict gap `|λ₋| < λ₊`, for every real coupling.
* `isingSpectralRatio_{nonneg, lt_one}`, `abs_isingSpectralRatio_lt_one`,
  `isingSpectralRatio_eq_tanh`: the ratio is `tanh β`, strictly inside the
  unit interval.
* `isingTransferData_hasStrictSpectralGap`,
  `isingTransferData_hasExponentialClustering` (amplitude one, exact ratio),
  `isingTransferData_hasUniformExponentialClustering`.
* `isingInterface`: `TransferOperatorInterface` instantiated with ZERO
  carried hypotheses.

Rate layer (`RateGlue.lean`):

* `FiniteTransferData.spectralRatio_{nonneg, lt_one}`.
* `FiniteTransferData.exponentialRate_pos`: the rate `-log (λ₂/λ₁)` is a
  genuine positive mass gap.
* `FiniteTransferData.spectralRatio_pow_eq_exp`,
  `FiniteTransferData.clustering_exp_form`: clustering in the
  `amplitude * exp (-rate * n)` form consumed by the parent M3 assembly.

Matrix algebra layer (`Matrix2Algebra.lean`):

* `Matrix2.{ext, mul, one, pow, trace}`.
* `transferMatrix_pow`: exact spectral closed form of `T^n` by induction.
* `trace_transferMatrix_pow`: `Z_n = λ₊^n + λ₋^n`.
* `transferMatrix_pow_mulVec_{plus, minus}`: eigenrelations for all powers.

## Frontier obligations (branch `frontier/M1`, statement-first, sorried)

`Frontier/PerronFrobenius.lean` (candidate for upstream Mathlib):

* `exists_perron_pair`, `eigenvalue_le_perron`,
  `eigenvalue_lt_perron_of_orthogonal`, `centered_power_bound` (constants
  still existential — MUST become explicit before feeding
  `FiniteTransferData.amplitude`).

`Frontier/GibbsChain.lean` (closes the T0 honesty gap: Gibbs measure from
first principles):

* `gibbsPartition_eq_trace`, `gibbsTwoPoint_eq`, `gibbsCorrelation_tendsto`
  (retroactive justification of `isingTwoPointCorrelation`).
* Closed local helpers now include `Spin.univ_eq`, `Matrix2.entry`,
  `Matrix2.mul_entry`, `Matrix2.pow_succ_entry`,
  `Matrix2.trace_eq_entry_sum`,
  `pairWeight_eq_isingTransferMatrix_entry`,
  `pairWeight_product_eq_transferMatrix_entry_product`,
  `gibbsPartition_eq_transferMatrix_entry_sum`,
  `trace_isingTransferMatrix_pow`, `pairWeight_self`, `pairWeight_of_ne`,
  `pairWeight_comm`, and `spinValue_mul_self`.

## Honest distance to the programme target

The dictionary gap <-> clustering is now unconditional on one real model with
exact constants (C = 1, ρ = tanh β, rate = -log tanh β). What separates this
satellite from serving an arbitrary strictly positive transfer kernel is
exactly the Perron-Frobenius block above. Gaussian chain (M3) not started.
Reflection positivity, OS reconstruction, and all Balaban/KP hypotheses
remain deliberately out of scope here.

## Frontier branch policy

Unchanged: statements-first work with `sorry` only on `frontier/*` branches,
each updating this file with exact sorried names.
