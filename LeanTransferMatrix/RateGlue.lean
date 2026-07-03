import LeanTransferMatrix.Finite
import Mathlib.Analysis.SpecialFunctions.Exp

/-!
# Rate glue: from spectral ratios to explicit exponential rates

Converts the ratio-form clustering of `FiniteTransferData` into the
`exp (-rate * n)` form consumed by the parent M3 assembly, with the exact
rate `-log (λ₂/λ₁)` and a positivity proof.

Reference: Levin, Peres, and Wilmer, 2009, "Markov Chains and Mixing Times",
Theorem 12.4, for the rate normalization.
-/

namespace LeanTransferMatrix
namespace FiniteTransferData

theorem spectralRatio_nonneg (D : FiniteTransferData)
    (h : HasStrictSpectralGap D) : 0 ≤ D.spectralRatio :=
  div_nonneg h.2.1 h.1.le

theorem spectralRatio_lt_one (D : FiniteTransferData)
    (h : HasStrictSpectralGap D) : D.spectralRatio < 1 := by
  unfold spectralRatio
  rw [div_lt_one h.1]
  exact h.2.2

/-- With a strict gap and a nondegenerate second eigenvalue, the exponential
rate `-log (λ₂/λ₁)` is strictly positive: a genuine mass gap. -/
theorem exponentialRate_pos (D : FiniteTransferData)
    (h : HasStrictSpectralGap D) (h2 : 0 < D.lambda2) :
    0 < D.exponentialRate := by
  unfold exponentialRate
  have hρ0 : 0 < D.spectralRatio := div_pos h2 h.1
  have hρ1 : D.spectralRatio < 1 := D.spectralRatio_lt_one h
  have hlog := Real.log_neg hρ0 hρ1
  linarith

/-- The spectral ratio power in exact exponential form:
`ρ ^ n = exp (-rate * n)`. -/
theorem spectralRatio_pow_eq_exp (D : FiniteTransferData)
    (h1 : 0 < D.lambda1) (h2 : 0 < D.lambda2) (n : ℕ) :
    D.spectralRatio ^ n = Real.exp (-D.exponentialRate * n) := by
  have hρ : 0 < D.spectralRatio := div_pos h2 h1
  have hrw : -D.exponentialRate * (n : ℝ)
      = (n : ℝ) * Real.log D.spectralRatio := by
    unfold exponentialRate
    ring
  rw [hrw, Real.exp_nat_mul, Real.exp_log hρ]

/-- Exponential clustering rewritten with the explicit rate: the form the
parent mass-gap assembly consumes. -/
theorem clustering_exp_form (D : FiniteTransferData)
    (hgap : HasStrictSpectralGap D) (h2 : 0 < D.lambda2)
    (hcl : HasExponentialClustering D) (n : ℕ) :
    |D.correlation n| ≤ D.amplitude * Real.exp (-D.exponentialRate * n) := by
  have h := hcl n
  rwa [D.spectralRatio_pow_eq_exp hgap.1 h2 n] at h

end FiniteTransferData
end LeanTransferMatrix
