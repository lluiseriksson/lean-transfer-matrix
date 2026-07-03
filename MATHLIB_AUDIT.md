# Mathlib Audit

Date: 2026-07-03

Audited against Mathlib commit `07642720480157414db592fa85b626dafb71355b`, matching the mother repo manifest.

## Relevant existing Mathlib material

* `Mathlib.Data.Matrix.Mul`
  * `Matrix.mulVec`, `Matrix.vecMul`, `Matrix.dotProduct`.
  * Enough for M0 explicit 2x2 transfer-matrix calculations.

* `Mathlib.LinearAlgebra.Matrix.ToLin`
  * `Matrix.mulVecLin`, `Matrix.toLin`, and matrix/linear-map bridges.
  * Relevant for future finite-dimensional operator statements.

* `Mathlib.LinearAlgebra.Eigenspace.Basic`
  * `Module.End.genEigenspace`, `HasEigenvector`, `HasEigenvalue`.
  * Relevant for future spectral decomposition statements.

* `Mathlib.LinearAlgebra.Matrix.Irreducible.Defs`
  * `Matrix.IsIrreducible`.
  * `Matrix.IsPrimitive`.
  * `Matrix.isIrreducible_iff_exists_pow_pos`.
  * `Matrix.IsPrimitive.isIrreducible`.

* `Mathlib.LinearAlgebra.Matrix.Stochastic`
  * `Matrix.rowStochastic`, `Matrix.colStochastic`, nonnegativity and preservation lemmas.
  * Relevant if transfer matrices are normalized to Markov kernels.

* `Mathlib.LinearAlgebra.Matrix.PosDef`
  * `Matrix.PosSemidef`, `Matrix.PosDef`, Hermitian/positive-definite matrix API.
  * Relevant for finite self-adjoint positive operators.

* `Mathlib.Analysis.Normed.Operator.FredholmAlternative`
  * Compact-operator spectral API, including nonzero spectrum/eigenvalue equivalence for compact operators.
  * More general than the immediate finite-dimensional need, but useful for later comparison.

## Missing or not yet sufficient

The audit did not find a ready-to-use Perron-Frobenius theorem giving, for a primitive nonnegative finite matrix:

* existence of a strictly positive dominant eigenvector;
* simplicity of the dominant eigenvalue;
* strict dominance over all other eigenvalues in modulus;
* a projection/decomposition estimate yielding exact correlation decay on the centered sector.

Mathlib has graph-theoretic primitivity definitions and some power-positivity lemmas, but the full Perron-Frobenius spectral package still appears to be frontier work for this repo or an upstream proposal.

## Upstream candidates

Likely Mathlib-worthy:

* Perron-Frobenius for primitive nonnegative matrices over `ℝ`.
* Spectral radius/eigenvalue bridge specialized to finite matrices, if not already convenient enough through existing APIs.
* Finite self-adjoint spectral decomposition estimates in a form usable for reversible Markov kernels.
