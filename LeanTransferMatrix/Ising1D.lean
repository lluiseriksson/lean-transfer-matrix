import Mathlib.Analysis.SpecialFunctions.Exp

/-!
# The one-dimensional Ising transfer matrix

This module closes milestone M0 in the zero-field two-state case: the symmetric
two by two transfer matrix has the two explicit eigenvectors needed for the
standard correlation computation.
-/

namespace LeanTransferMatrix
namespace Ising1D

/-- The two spin states used for the one-dimensional Ising chain. -/
inductive Spin where
  | up
  | down
  deriving DecidableEq, Repr

open Spin

/-- A concrete real `2 x 2` matrix indexed by `Spin`. -/
structure Matrix2 where
  upUp : ℝ
  upDown : ℝ
  downUp : ℝ
  downDown : ℝ

/-- Vectors indexed by the two spin states. -/
abbrev Vector2 := Spin → ℝ

/-- Matrix-vector multiplication for concrete `2 x 2` matrices. -/
def Matrix2.mulVec (M : Matrix2) (v : Vector2) : Vector2
  | up => M.upUp * v up + M.upDown * v down
  | down => M.downUp * v up + M.downDown * v down

/-- Scalar multiplication of a two-spin vector. -/
def smulVec (c : ℝ) (v : Vector2) : Vector2 :=
  fun s => c * v s

/-- The constant vector, corresponding to the Perron direction of the zero-field matrix. -/
def plusVector : Vector2
  | up => 1
  | down => 1

/-- The odd spin vector. -/
def minusVector : Vector2
  | up => 1
  | down => -1

/-- The zero-field two-state transfer matrix with diagonal weight `a` and off-diagonal weight `b`. -/
def transferMatrix (a b : ℝ) : Matrix2 where
  upUp := a
  upDown := b
  downUp := b
  downDown := a

/--
The Perron-direction eigenvalue of the zero-field one-dimensional Ising transfer matrix.
Reference: Baxter (1982), *Exactly Solved Models in Statistical Mechanics*, pp. 32-38.
-/
def lambdaPlus (a b : ℝ) : ℝ :=
  a + b

/--
The odd-sector eigenvalue of the zero-field one-dimensional Ising transfer matrix.
Reference: Baxter (1982), *Exactly Solved Models in Statistical Mechanics*, pp. 32-38.
-/
def lambdaMinus (a b : ℝ) : ℝ :=
  a - b

/--
The constant vector is an eigenvector with eigenvalue `a + b`.
Reference: Baxter (1982), *Exactly Solved Models in Statistical Mechanics*, pp. 32-38.
-/
theorem transferMatrix_mulVec_plus (a b : ℝ) :
    (transferMatrix a b).mulVec plusVector = smulVec (lambdaPlus a b) plusVector := by
  funext s
  cases s
  · simp [Matrix2.mulVec, transferMatrix, plusVector, smulVec, lambdaPlus]
  · simp [Matrix2.mulVec, transferMatrix, plusVector, smulVec, lambdaPlus, add_comm]

/--
The odd vector is an eigenvector with eigenvalue `a - b`.
Reference: Baxter (1982), *Exactly Solved Models in Statistical Mechanics*, pp. 32-38.
-/
theorem transferMatrix_mulVec_minus (a b : ℝ) :
    (transferMatrix a b).mulVec minusVector = smulVec (lambdaMinus a b) minusVector := by
  funext s
  cases s
  · simp [Matrix2.mulVec, transferMatrix, minusVector, smulVec, lambdaMinus, sub_eq_add_neg]
  · simp [Matrix2.mulVec, transferMatrix, minusVector, smulVec, lambdaMinus, sub_eq_add_neg]

/-- The transfer-matrix spectral ratio in the odd sector. -/
noncomputable def spectralRatio (a b : ℝ) : ℝ :=
  lambdaMinus a b / lambdaPlus a b

/--
The normalized two-point function of the zero-field one-dimensional Ising chain at distance `n`.
This is intentionally the transfer-matrix expression; the statistical-mechanical construction of
the Gibbs measure is outside this satellite.
-/
noncomputable def twoPointCorrelation (a b : ℝ) (n : ℕ) : ℝ :=
  spectralRatio a b ^ n

/--
The two-point correlation is exactly the `n`-th power of the transfer-matrix spectral ratio.
Reference: Baxter (1982), *Exactly Solved Models in Statistical Mechanics*, pp. 32-38.
-/
theorem twoPointCorrelation_eq_spectralRatio_pow (a b : ℝ) (n : ℕ) :
    twoPointCorrelation a b n = spectralRatio a b ^ n := by
  rfl

/-- Boltzmann weight for aligned spins at inverse temperature/coupling `beta`. -/
noncomputable def alignedWeight (beta : ℝ) : ℝ :=
  Real.exp beta

/-- Boltzmann weight for anti-aligned spins at inverse temperature/coupling `beta`. -/
noncomputable def antiAlignedWeight (beta : ℝ) : ℝ :=
  Real.exp (-beta)

/-- The zero-field nearest-neighbour Ising transfer matrix. -/
noncomputable def isingTransferMatrix (beta : ℝ) : Matrix2 :=
  transferMatrix (alignedWeight beta) (antiAlignedWeight beta)

/-- The dominant transfer-matrix eigenvalue in the zero-field Ising chain. -/
noncomputable def isingLambdaPlus (beta : ℝ) : ℝ :=
  lambdaPlus (alignedWeight beta) (antiAlignedWeight beta)

/-- The odd-sector transfer-matrix eigenvalue in the zero-field Ising chain. -/
noncomputable def isingLambdaMinus (beta : ℝ) : ℝ :=
  lambdaMinus (alignedWeight beta) (antiAlignedWeight beta)

/--
The constant-vector eigenrelation for the zero-field Ising transfer matrix.
Reference: Baxter (1982), *Exactly Solved Models in Statistical Mechanics*, pp. 32-38.
-/
theorem isingTransferMatrix_mulVec_plus (beta : ℝ) :
    (isingTransferMatrix beta).mulVec plusVector =
      smulVec (isingLambdaPlus beta) plusVector := by
  simpa [isingTransferMatrix, isingLambdaPlus] using
    transferMatrix_mulVec_plus (alignedWeight beta) (antiAlignedWeight beta)

/--
The odd-vector eigenrelation for the zero-field Ising transfer matrix.
Reference: Baxter (1982), *Exactly Solved Models in Statistical Mechanics*, pp. 32-38.
-/
theorem isingTransferMatrix_mulVec_minus (beta : ℝ) :
    (isingTransferMatrix beta).mulVec minusVector =
      smulVec (isingLambdaMinus beta) minusVector := by
  simpa [isingTransferMatrix, isingLambdaMinus] using
    transferMatrix_mulVec_minus (alignedWeight beta) (antiAlignedWeight beta)

/-- The Ising two-point function in transfer-matrix form. -/
noncomputable def isingTwoPointCorrelation (beta : ℝ) (n : ℕ) : ℝ :=
  twoPointCorrelation (alignedWeight beta) (antiAlignedWeight beta) n

/--
The Ising two-point function equals the `n`-th power of the eigenvalue ratio.
Reference: Baxter (1982), *Exactly Solved Models in Statistical Mechanics*, pp. 32-38.
-/
theorem isingTwoPointCorrelation_eq_spectralRatio_pow (beta : ℝ) (n : ℕ) :
    isingTwoPointCorrelation beta n =
      (isingLambdaMinus beta / isingLambdaPlus beta) ^ n := by
  rfl

end Ising1D
end LeanTransferMatrix
