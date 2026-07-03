import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Basic

/-!
# Finite transfer-operator interface

This module contains the hypothesis-explicit finite-dimensional dictionary used
by `LeanTransferMatrix.Interfaces`. It deliberately does not assert an unproved
Perron-Frobenius theorem.
-/

namespace LeanTransferMatrix

/--
Numerical transfer data for a finite-dimensional model after its transfer operator has been
identified and normalized.
-/
structure FiniteTransferData where
  /-- Dominant transfer eigenvalue. -/
  lambda1 : ℝ
  /-- Second transfer eigenvalue/modulus controlling the two-point sector. -/
  lambda2 : ℝ
  /-- Amplitude in the two-point correlation bound. -/
  amplitude : ℝ
  /-- Two-point correlation at lattice distance `n`. -/
  correlation : ℕ → ℝ

/-- The spectral ratio `lambda2 / lambda1`. -/
noncomputable def FiniteTransferData.spectralRatio (D : FiniteTransferData) : ℝ :=
  D.lambda2 / D.lambda1

/-- The exponential rate corresponding to the transfer spectral ratio. -/
noncomputable def FiniteTransferData.exponentialRate (D : FiniteTransferData) : ℝ :=
  -Real.log D.spectralRatio

/-- A strictly positive transfer gap in normalized finite-dimensional data. -/
def HasStrictSpectralGap (D : FiniteTransferData) : Prop :=
  0 < D.lambda1 ∧ 0 ≤ D.lambda2 ∧ D.lambda2 < D.lambda1

/-- Exponential clustering with the exact transfer-matrix ratio. -/
noncomputable def HasExponentialClustering (D : FiniteTransferData) : Prop :=
  ∀ n : ℕ, |D.correlation n| ≤ D.amplitude * D.spectralRatio ^ n

/-- Uniform exponential clustering with some rate `rho < 1`. -/
def HasUniformExponentialClustering (D : FiniteTransferData) : Prop :=
  ∃ C rho : ℝ, 0 ≤ C ∧ 0 ≤ rho ∧ rho < 1 ∧
    ∀ n : ℕ, |D.correlation n| ≤ C * rho ^ n

/--
Forward finite-dimensional assembly: a spectral gap gives clustering once the transfer-operator
estimate has been supplied as an explicit hypothesis.
Reference: Levin, Peres, and Wilmer (2009), *Markov Chains and Mixing Times*, Theorems 12.3-12.4.
-/
theorem spectralGap_to_exponentialClustering
    (D : FiniteTransferData)
    (hgap : HasStrictSpectralGap D)
    (htransfer : HasStrictSpectralGap D → HasExponentialClustering D) :
    HasExponentialClustering D :=
  htransfer hgap

/--
Reverse finite-dimensional assembly: uniform clustering gives a gap once the finite transfer
identification theorem has been supplied as an explicit hypothesis.
Reference: Levin, Peres, and Wilmer (2009), *Markov Chains and Mixing Times*, Theorems 12.3-12.4.
-/
theorem exponentialClustering_to_spectralGap
    (D : FiniteTransferData)
    (hcluster : HasUniformExponentialClustering D)
    (htransfer : HasUniformExponentialClustering D → HasStrictSpectralGap D) :
    HasStrictSpectralGap D :=
  htransfer hcluster

end LeanTransferMatrix
