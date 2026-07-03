import LeanTransferMatrix.Ising1D

/-!
# Closed form for powers of the symmetric 2x2 transfer matrix

Multiplication, powers, and trace for `Matrix2`, and the exact spectral
closed form `T^n` in the eigenbasis: the algebraic engine behind partition
functions `Z_n = λ₊^n + λ₋^n` and finite-chain correlations.

Reference: Baxter, 1982, "Exactly Solved Models in Statistical Mechanics",
pp. 32-38.
-/

namespace LeanTransferMatrix
namespace Ising1D

@[ext] theorem Matrix2.ext {M N : Matrix2}
    (h1 : M.upUp = N.upUp) (h2 : M.upDown = N.upDown)
    (h3 : M.downUp = N.downUp) (h4 : M.downDown = N.downDown) : M = N := by
  cases M
  cases N
  simp_all

/-- Matrix product of concrete 2x2 matrices. -/
def Matrix2.mul (M N : Matrix2) : Matrix2 where
  upUp := M.upUp * N.upUp + M.upDown * N.downUp
  upDown := M.upUp * N.upDown + M.upDown * N.downDown
  downUp := M.downUp * N.upUp + M.downDown * N.downUp
  downDown := M.downUp * N.upDown + M.downDown * N.downDown

/-- The 2x2 identity. -/
def Matrix2.one : Matrix2 :=
  ⟨1, 0, 0, 1⟩

/-- Matrix powers. -/
def Matrix2.pow (M : Matrix2) : ℕ → Matrix2
  | 0 => Matrix2.one
  | n + 1 => (Matrix2.pow M n).mul M

/-- The trace. -/
def Matrix2.trace (M : Matrix2) : ℝ :=
  M.upUp + M.downDown

/-- Exact spectral closed form: powers of the symmetric transfer matrix stay
in the two-parameter symmetric family, with coefficients given by the
eigenvalue powers. -/
theorem transferMatrix_pow (a b : ℝ) (n : ℕ) :
    (transferMatrix a b).pow n
      = transferMatrix ((lambdaPlus a b ^ n + lambdaMinus a b ^ n) / 2)
          ((lambdaPlus a b ^ n - lambdaMinus a b ^ n) / 2) := by
  induction n with
  | zero =>
    apply Matrix2.ext <;>
      simp [Matrix2.pow, Matrix2.one, transferMatrix]
  | succ n ih =>
    show ((transferMatrix a b).pow n).mul (transferMatrix a b) = _
    rw [ih]
    apply Matrix2.ext <;>
      simp only [Matrix2.mul, transferMatrix, lambdaPlus, lambdaMinus] <;>
        ring

/-- Partition function of the periodic chain of length `n`:
`Z_n = tr (T^n) = λ₊^n + λ₋^n`. -/
theorem trace_transferMatrix_pow (a b : ℝ) (n : ℕ) :
    ((transferMatrix a b).pow n).trace
      = lambdaPlus a b ^ n + lambdaMinus a b ^ n := by
  rw [transferMatrix_pow]
  show (lambdaPlus a b ^ n + lambdaMinus a b ^ n) / 2
      + (lambdaPlus a b ^ n + lambdaMinus a b ^ n) / 2 = _
  ring

/-- The Perron direction is an eigenvector of every power, with eigenvalue
`λ₊^n`. -/
theorem transferMatrix_pow_mulVec_plus (a b : ℝ) (n : ℕ) :
    ((transferMatrix a b).pow n).mulVec plusVector
      = smulVec (lambdaPlus a b ^ n) plusVector := by
  rw [transferMatrix_pow]
  funext s
  cases s <;>
    simp [Matrix2.mulVec, transferMatrix, plusVector, smulVec] <;> ring

/-- The odd direction is an eigenvector of every power, with eigenvalue
`λ₋^n`. -/
theorem transferMatrix_pow_mulVec_minus (a b : ℝ) (n : ℕ) :
    ((transferMatrix a b).pow n).mulVec minusVector
      = smulVec (lambdaMinus a b ^ n) minusVector := by
  rw [transferMatrix_pow]
  funext s
  cases s <;>
    simp [Matrix2.mulVec, transferMatrix, minusVector, smulVec] <;> ring

end Ising1D
end LeanTransferMatrix
