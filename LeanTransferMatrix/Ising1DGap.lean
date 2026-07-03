import LeanTransferMatrix.Ising1D
import LeanTransferMatrix.Finite
import LeanTransferMatrix.Interfaces

/-!
# Quantitative spectral gap for the zero-field Ising chain

The ferromagnetic (`0 ≤ β`) zero-field Ising chain discharges BOTH explicit
hypotheses of `TransferOperatorInterface`: strict spectral gap and exponential
clustering are theorems, not carried data.  `isingInterface` below is the
first fully unconditional instance of the parent-facing interface.

Reference: Baxter, 1982, "Exactly Solved Models in Statistical Mechanics",
pp. 32-38.
-/

namespace LeanTransferMatrix
namespace Ising1D

/-- The Ising spectral ratio `λ₋/λ₊`. -/
noncomputable def isingSpectralRatio (β : ℝ) : ℝ :=
  spectralRatio (alignedWeight β) (antiAlignedWeight β)

theorem isingSpectralRatio_def (β : ℝ) :
    isingSpectralRatio β = isingLambdaMinus β / isingLambdaPlus β := rfl

/-- The dominant eigenvalue `e^β + e^{-β}` is positive for every real `β`. -/
theorem isingLambdaPlus_pos (β : ℝ) : 0 < isingLambdaPlus β := by
  have h1 := Real.exp_pos β
  have h2 := Real.exp_pos (-β)
  unfold isingLambdaPlus lambdaPlus alignedWeight antiAlignedWeight
  linarith

/-- Ferromagnetic regime: the odd-sector eigenvalue is nonnegative. -/
theorem isingLambdaMinus_nonneg {β : ℝ} (hβ : 0 ≤ β) :
    0 ≤ isingLambdaMinus β := by
  have h : Real.exp (-β) ≤ Real.exp β := Real.exp_le_exp.mpr (by linarith)
  unfold isingLambdaMinus lambdaMinus alignedWeight antiAlignedWeight
  linarith

/-- Strict spectral gap: `λ₋ < λ₊` for every real `β`. -/
theorem isingLambdaMinus_lt_isingLambdaPlus (β : ℝ) :
    isingLambdaMinus β < isingLambdaPlus β := by
  have h2 := Real.exp_pos (-β)
  unfold isingLambdaMinus isingLambdaPlus lambdaMinus lambdaPlus
    alignedWeight antiAlignedWeight
  linarith

/-- Two-sided gap: `|λ₋| < λ₊` for every real `β`. -/
theorem abs_isingLambdaMinus_lt (β : ℝ) :
    |isingLambdaMinus β| < isingLambdaPlus β := by
  have h1 := Real.exp_pos β
  have h2 := Real.exp_pos (-β)
  unfold isingLambdaMinus isingLambdaPlus lambdaMinus lambdaPlus
    alignedWeight antiAlignedWeight
  rw [abs_lt]
  constructor <;> linarith

theorem isingSpectralRatio_nonneg {β : ℝ} (hβ : 0 ≤ β) :
    0 ≤ isingSpectralRatio β := by
  rw [isingSpectralRatio_def]
  exact div_nonneg (isingLambdaMinus_nonneg hβ) (isingLambdaPlus_pos β).le

theorem isingSpectralRatio_lt_one (β : ℝ) : isingSpectralRatio β < 1 := by
  rw [isingSpectralRatio_def, div_lt_one (isingLambdaPlus_pos β)]
  exact isingLambdaMinus_lt_isingLambdaPlus β

theorem abs_isingSpectralRatio_lt_one (β : ℝ) : |isingSpectralRatio β| < 1 := by
  rw [isingSpectralRatio_def, abs_div, abs_of_pos (isingLambdaPlus_pos β),
    div_lt_one (isingLambdaPlus_pos β)]
  exact abs_isingLambdaMinus_lt β

/-- The Ising spectral ratio is the hyperbolic tangent of the coupling.
Reference: Baxter, 1982, p. 36. -/
theorem isingSpectralRatio_eq_tanh (β : ℝ) :
    isingSpectralRatio β = Real.tanh β := by
  rw [isingSpectralRatio_def, Real.tanh_eq_sinh_div_cosh, Real.sinh_eq,
    Real.cosh_eq]
  unfold isingLambdaMinus isingLambdaPlus lambdaMinus lambdaPlus
    alignedWeight antiAlignedWeight
  have h : Real.exp β + Real.exp (-β) ≠ 0 := by positivity
  field_simp

/-- The Ising chain packaged as finite transfer data with amplitude one. -/
noncomputable def isingTransferData (β : ℝ) : FiniteTransferData where
  lambda1 := isingLambdaPlus β
  lambda2 := isingLambdaMinus β
  amplitude := 1
  correlation := fun n => isingTwoPointCorrelation β n

theorem isingTransferData_spectralRatio (β : ℝ) :
    (isingTransferData β).spectralRatio = isingSpectralRatio β := rfl

/-- The Ising chain has a strict spectral gap in the ferromagnetic regime:
proved, not hypothesized. -/
theorem isingTransferData_hasStrictSpectralGap {β : ℝ} (hβ : 0 ≤ β) :
    HasStrictSpectralGap (isingTransferData β) :=
  ⟨isingLambdaPlus_pos β, isingLambdaMinus_nonneg hβ,
    isingLambdaMinus_lt_isingLambdaPlus β⟩

/-- The Ising chain clusters exponentially with amplitude one and the exact
spectral ratio: proved, not hypothesized. -/
theorem isingTransferData_hasExponentialClustering {β : ℝ} (hβ : 0 ≤ β) :
    HasExponentialClustering (isingTransferData β) := by
  intro n
  have hr : 0 ≤ isingSpectralRatio β := isingSpectralRatio_nonneg hβ
  have h1 : (isingTransferData β).correlation n = isingSpectralRatio β ^ n := rfl
  have h2 : (isingTransferData β).spectralRatio = isingSpectralRatio β := rfl
  have h3 : (isingTransferData β).amplitude = 1 := rfl
  rw [h1, h2, h3, abs_of_nonneg (pow_nonneg hr n), one_mul]

/-- Uniform exponential clustering with `C = 1`, `ρ = λ₋/λ₊ < 1`: proved. -/
theorem isingTransferData_hasUniformExponentialClustering {β : ℝ} (hβ : 0 ≤ β) :
    HasUniformExponentialClustering (isingTransferData β) := by
  refine ⟨1, isingSpectralRatio β, zero_le_one, isingSpectralRatio_nonneg hβ,
    isingSpectralRatio_lt_one β, ?_⟩
  intro n
  have h1 : (isingTransferData β).correlation n = isingSpectralRatio β ^ n := rfl
  rw [h1, abs_of_nonneg (pow_nonneg (isingSpectralRatio_nonneg hβ) n), one_mul]

/-- First fully unconditional instance of the parent-facing interface: on the
ferromagnetic zero-field Ising chain both transfer hypotheses are theorems.
Nothing is carried. -/
noncomputable def isingInterface (β : ℝ) (hβ : 0 ≤ β) :
    TransferOperatorInterface where
  data := isingTransferData β
  gapToClusteringHypothesis := fun _ =>
    isingTransferData_hasExponentialClustering hβ
  clusteringToGapHypothesis := fun _ =>
    isingTransferData_hasStrictSpectralGap hβ

end Ising1D
end LeanTransferMatrix
