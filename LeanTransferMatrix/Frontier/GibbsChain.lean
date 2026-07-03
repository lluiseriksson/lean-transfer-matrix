import Mathlib.Topology.Basic
import LeanTransferMatrix.Ising1D
import LeanTransferMatrix.Ising1DGap
import LeanTransferMatrix.Matrix2Algebra

/-!
# Frontier: the Gibbs chain from first principles

Statement-first targets closing the honesty gap declared at T0: the M0/M1
layer computes with the transfer matrix, but the Gibbs measure itself is not
yet constructed.  This file states the missing identifications: partition
function equals the trace of `T^n`, the periodic two-point function has the
exact two-eigenvalue form, and the thermodynamic limit recovers
`(λ₋/λ₊)^k = tanh(β)^k`.  Every `sorry` is a frontier obligation; NEVER merge
to `main`.

Reference: Baxter, 1982, "Exactly Solved Models in Statistical Mechanics",
pp. 32-38.
-/

namespace LeanTransferMatrix
namespace Ising1D

instance : Fintype Spin :=
  ⟨{Spin.up, Spin.down}, by intro s; cases s <;> simp⟩

/-- Boltzmann pair weight. -/
noncomputable def pairWeight (β : ℝ) (s t : Spin) : ℝ :=
  if s = t then Real.exp β else Real.exp (-β)

/-- Spin observable `±1`. -/
def spinValue : Spin → ℝ
  | Spin.up => 1
  | Spin.down => -1

/-- Partition function of the periodic chain of length `n + 1`, summed over
all configurations: the first-principles object. -/
noncomputable def gibbsPartition (β : ℝ) (n : ℕ) : ℝ :=
  ∑ σ : Fin (n + 1) → Spin, ∏ i : Fin (n + 1), pairWeight β (σ i) (σ (i + 1))

/-- Unnormalized periodic two-point function at separation `k`. -/
noncomputable def gibbsTwoPoint (β : ℝ) (n k : ℕ) : ℝ :=
  ∑ σ : Fin (n + 1) → Spin,
    spinValue (σ 0) * spinValue (σ (Fin.ofNat (n + 1) k))
      * ∏ i : Fin (n + 1), pairWeight β (σ i) (σ (i + 1))

/-- The configuration sum equals the transfer-matrix trace:
`Z_{n+1} = tr (T^{n+1}) = λ₊^{n+1} + λ₋^{n+1}`. -/
theorem gibbsPartition_eq_trace (β : ℝ) (n : ℕ) :
    gibbsPartition β n = ((isingTransferMatrix β).pow (n + 1)).trace := by
  sorry

/-- Exact periodic two-point function: two-eigenvalue form.
`⟨σ₀ σ_k⟩ · Z = λ₊^{n+1-k} λ₋^k + λ₋^{n+1-k} λ₊^k` for `k ≤ n + 1`. -/
theorem gibbsTwoPoint_eq (β : ℝ) (n k : ℕ) (hk : k ≤ n + 1) :
    gibbsTwoPoint β n k
      = isingLambdaPlus β ^ (n + 1 - k) * isingLambdaMinus β ^ k
        + isingLambdaMinus β ^ (n + 1 - k) * isingLambdaPlus β ^ k := by
  sorry

/-- Thermodynamic limit: the normalized periodic two-point function converges
to the transfer-matrix expression `(λ₋/λ₊)^k` already exported on `main`.
This is the theorem that retroactively justifies `isingTwoPointCorrelation`. -/
theorem gibbsCorrelation_tendsto (β : ℝ) (k : ℕ) :
    Filter.Tendsto (fun n => gibbsTwoPoint β n k / gibbsPartition β n)
      Filter.atTop (nhds (isingSpectralRatio β ^ k)) := by
  sorry

end Ising1D
end LeanTransferMatrix
