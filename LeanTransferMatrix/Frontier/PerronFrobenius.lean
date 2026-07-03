import Mathlib.LinearAlgebra.Matrix.Symmetric
import LeanTransferMatrix.Finite

/-!
# Frontier: Perron-Frobenius for positive symmetric matrices

Statement-first targets for the general finite-dimensional M1 theorem.  Every
`sorry` is a frontier obligation tracked in `HYPOTHESIS_FRONTIER.md`; this
file must NEVER be merged to `main`.  Mathlib route: `Matrix.IsHermitian.
spectral_theorem` plus a positivity argument for the Perron pair; candidate
for upstream Mathlib contribution.

Reference: Seneta, 1981, "Non-negative Matrices and Markov Chains",
Theorem 1.1, p. 3; Levin-Peres-Wilmer, 2009, Theorem 12.4.
-/

namespace LeanTransferMatrix
namespace Frontier

open Matrix

variable {d : ℕ}

/-- Existence of a positive Perron eigenpair for an entrywise-positive
symmetric real matrix. -/
theorem exists_perron_pair (A : Matrix (Fin (d + 1)) (Fin (d + 1)) ℝ)
    (hsymm : A.IsSymm) (hpos : ∀ i j, 0 < A i j) :
    ∃ (lam : ℝ) (v : Fin (d + 1) → ℝ),
      0 < lam ∧ (∀ i, 0 < v i) ∧ A.mulVec v = lam • v := by
  sorry

/-- Every eigenvalue is dominated by the Perron eigenvalue. -/
theorem eigenvalue_le_perron (A : Matrix (Fin (d + 1)) (Fin (d + 1)) ℝ)
    (hsymm : A.IsSymm) (hpos : ∀ i j, 0 < A i j)
    (lam : ℝ) (v : Fin (d + 1) → ℝ) (hlam : 0 < lam) (hv : ∀ i, 0 < v i)
    (heig : A.mulVec v = lam • v)
    (mu : ℝ) (w : Fin (d + 1) → ℝ) (hw : w ≠ 0)
    (heigw : A.mulVec w = mu • w) :
    |mu| ≤ lam := by
  sorry

/-- Strict gap on the orthogonal complement of the Perron direction: the
positive-entry hypothesis forbids `|mu| = lam` there.  This is the exact
input that upgrades `FiniteTransferData` hypotheses to theorems for any
strictly positive transfer kernel. -/
theorem eigenvalue_lt_perron_of_orthogonal
    (A : Matrix (Fin (d + 1)) (Fin (d + 1)) ℝ)
    (hsymm : A.IsSymm) (hpos : ∀ i j, 0 < A i j)
    (lam : ℝ) (v : Fin (d + 1) → ℝ) (hlam : 0 < lam) (hv : ∀ i, 0 < v i)
    (heig : A.mulVec v = lam • v)
    (mu : ℝ) (w : Fin (d + 1) → ℝ) (hw : w ≠ 0)
    (horth : ∑ i, w i * v i = 0)
    (heigw : A.mulVec w = mu • w) :
    |mu| < lam := by
  sorry

/-- Centered-sector power bound: subtracting the Perron projection leaves a
matrix whose powers decay with the second eigenvalue.  TODO(frontier):
replace `∃ C rho` by explicit constants from the spectral decomposition
before this can feed `FiniteTransferData.amplitude`. -/
theorem centered_power_bound (A : Matrix (Fin (d + 1)) (Fin (d + 1)) ℝ)
    (hsymm : A.IsSymm) (hpos : ∀ i j, 0 < A i j)
    (lam : ℝ) (v : Fin (d + 1) → ℝ) (hlam : 0 < lam) (hv : ∀ i, 0 < v i)
    (hnorm : ∑ i, v i * v i = 1)
    (heig : A.mulVec v = lam • v) :
    ∃ C rho : ℝ, 0 ≤ C ∧ 0 ≤ rho ∧ rho < 1 ∧
      ∀ (n : ℕ) (i j : Fin (d + 1)),
        |(A ^ n) i j - lam ^ n * (v i * v j)| ≤ C * lam ^ n * rho ^ n := by
  sorry

end Frontier
end LeanTransferMatrix
