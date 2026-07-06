import LeanTransferMatrix.RateGlue

/-!
# Finite-window extraction guardrail

This module records a small, hypothesis-explicit contract for finite-window
mass extraction from two positive transfer eigenvalues. It does not identify a
Yang-Mills Hamiltonian and does not prove any terminal-scale source theorem.
-/

namespace LeanTransferMatrix

/--
Numerical data for a finite-window transfer-matrix extraction contract.

The intended window is `windowFloor <= windowSize` and
`windowSize < kappa / renormalizedMass`. The final field is only the explicit
error budget supplied by a downstream extraction argument.
-/
structure FiniteWindowExtractionData where
  /-- Underlying finite transfer data with two controlling eigenvalues. -/
  transfer : FiniteTransferData
  /-- Lower endpoint `C` of the finite extraction window. -/
  windowFloor : ℝ
  /-- Window scale `M` at which extraction is attempted. -/
  windowSize : ℝ
  /-- Numerator `kappa` in the upper finite-window cutoff. -/
  kappa : ℝ
  /-- Renormalized mass scale `m_k` used in the upper finite-window cutoff. -/
  renormalizedMass : ℝ
  /-- Explicit additive error budget carried by the extraction argument. -/
  extractionError : ℝ

/-- The extraction error budget is explicit and nonnegative. -/
def FiniteWindowErrorBound (W : FiniteWindowExtractionData) : Prop :=
  0 ≤ W.extractionError

/-- The finite upper-window condition `M < kappa / m_k`. -/
def FiniteWindowUpperBound (W : FiniteWindowExtractionData) : Prop :=
  W.windowSize < W.kappa / W.renormalizedMass

/-- The inverted v1-style lower-bound route `M > kappa / m_k`. -/
def InvertedRegimeLowerBound (W : FiniteWindowExtractionData) : Prop :=
  W.kappa / W.renormalizedMass < W.windowSize

/--
Finite-window extraction hypotheses. This is a contract for consumers: the
transfer eigenvalues, finite window, and error control are all explicit inputs.
-/
structure FiniteWindowExtractionHypotheses (W : FiniteWindowExtractionData) : Prop where
  /-- Dominant eigenvalue is positive. -/
  lambda1_pos : 0 < W.transfer.lambda1
  /-- Second eigenvalue is positive for the logarithmic rate form. -/
  lambda2_pos : 0 < W.transfer.lambda2
  /-- The second eigenvalue is strictly below the dominant one. -/
  lambda2_lt_lambda1 : W.transfer.lambda2 < W.transfer.lambda1
  /-- Lower endpoint of the finite extraction window. -/
  windowLower : W.windowFloor ≤ W.windowSize
  /-- Upper endpoint of the finite extraction window. -/
  windowUpper : FiniteWindowUpperBound W
  /-- Explicit nonnegative extraction error budget. -/
  errorBound : FiniteWindowErrorBound W

/-- The finite-window hypotheses package the existing strict spectral gap contract. -/
theorem FiniteWindowExtractionHypotheses.hasStrictSpectralGap
    {W : FiniteWindowExtractionData}
    (h : FiniteWindowExtractionHypotheses W) :
    HasStrictSpectralGap W.transfer :=
  ⟨h.lambda1_pos, h.lambda2_pos.le, h.lambda2_lt_lambda1⟩

/-- The finite-window hypotheses expose the upper-window condition by name. -/
theorem FiniteWindowExtractionHypotheses.hasFiniteWindowUpperBound
    {W : FiniteWindowExtractionData}
    (h : FiniteWindowExtractionHypotheses W) :
    FiniteWindowUpperBound W :=
  h.windowUpper

/--
Guardrail proposition: an inverted lower-bound route is not, by itself, a
finite upper-window extraction regime.
-/
def FiniteWindowExtractionRejectsInvertedRegime
    (W : FiniteWindowExtractionData) : Prop :=
  InvertedRegimeLowerBound W → ¬ FiniteWindowUpperBound W

/-- The guardrail follows directly from incompatibility of strict inequalities. -/
theorem finiteWindowExtractionRejectsInvertedRegime
    (W : FiniteWindowExtractionData) :
    FiniteWindowExtractionRejectsInvertedRegime W := by
  intro hinverted hfinite
  exact (not_lt_of_ge hinverted.le) hfinite

end LeanTransferMatrix
