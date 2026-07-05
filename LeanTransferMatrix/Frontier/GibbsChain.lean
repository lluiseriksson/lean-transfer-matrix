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

/-- The explicit finite universe of the two spin states. -/
theorem Spin.univ_eq : (Finset.univ : Finset Spin) = {Spin.up, Spin.down} := by
  ext s
  cases s <;> simp

/-- Boltzmann pair weight. -/
noncomputable def pairWeight (β : ℝ) (s t : Spin) : ℝ :=
  if s = t then Real.exp β else Real.exp (-β)

/-- Spin observable `±1`. -/
def spinValue : Spin → ℝ
  | Spin.up => 1
  | Spin.down => -1

/-- Matrix entry, indexed by the two spin states. -/
def Matrix2.entry (M : Matrix2) : Spin → Spin → ℝ
  | Spin.up, Spin.up => M.upUp
  | Spin.up, Spin.down => M.upDown
  | Spin.down, Spin.up => M.downUp
  | Spin.down, Spin.down => M.downDown

/-- Entrywise form of concrete `2 x 2` matrix multiplication. -/
theorem Matrix2.mul_entry (M N : Matrix2) (s t : Spin) :
    (M.mul N).entry s t = ∑ u : Spin, M.entry s u * N.entry u t := by
  cases s <;> cases t <;>
    simp [Matrix2.mul, Matrix2.entry, Spin.univ_eq]

/-- Entrywise form of the recursive power step. -/
theorem Matrix2.pow_succ_entry (M : Matrix2) (n : ℕ) (s t : Spin) :
    (M.pow (n + 1)).entry s t = ∑ u : Spin, (M.pow n).entry s u * M.entry u t := by
  simp [Matrix2.pow, Matrix2.mul_entry]

/-- Trace as the sum over diagonal entries, in the `Spin` indexing used by
the Gibbs configuration sum. -/
theorem Matrix2.trace_eq_entry_sum (M : Matrix2) :
    M.trace = ∑ s : Spin, M.entry s s := by
  simp [Matrix2.trace, Matrix2.entry, Spin.univ_eq]

/-- One-step trace expansion: the diagonal trace of `M^(n+1)` is a sum over
one intermediate spin. This is the local induction step needed for the
configuration-sum-to-trace bridge. -/
theorem Matrix2.trace_pow_succ_eq_entry_sum (M : Matrix2) (n : ℕ) :
    (M.pow (n + 1)).trace
      = ∑ s : Spin, ∑ t : Spin, (M.pow n).entry s t * M.entry t s := by
  rw [Matrix2.trace_eq_entry_sum]
  apply Finset.sum_congr rfl
  intro s _
  rw [Matrix2.pow_succ_entry]

/-- Partition function of the periodic chain of length `n + 1`, summed over
all configurations: the first-principles object. -/
noncomputable def gibbsPartition (β : ℝ) (n : ℕ) : ℝ :=
  ∑ σ : Fin (n + 1) → Spin, ∏ i : Fin (n + 1), pairWeight β (σ i) (σ (i + 1))

/-- Unnormalized periodic two-point function at separation `k`. -/
noncomputable def gibbsTwoPoint (β : ℝ) (n k : ℕ) : ℝ :=
  ∑ σ : Fin (n + 1) → Spin,
    spinValue (σ 0) * spinValue (σ (Fin.ofNat (n + 1) k))
      * ∏ i : Fin (n + 1), pairWeight β (σ i) (σ (i + 1))

/-- Equal neighbouring spins contribute the aligned Boltzmann weight. -/
@[simp] theorem pairWeight_self (β : ℝ) (s : Spin) :
    pairWeight β s s = Real.exp β := by
  simp [pairWeight]

/-- Unequal neighbouring spins contribute the anti-aligned Boltzmann weight. -/
theorem pairWeight_of_ne {β : ℝ} {s t : Spin} (hst : s ≠ t) :
    pairWeight β s t = Real.exp (-β) := by
  simp [pairWeight, hst]

/-- The nearest-neighbour weight is symmetric in the two spins. -/
theorem pairWeight_comm (β : ℝ) (s t : Spin) :
    pairWeight β s t = pairWeight β t s := by
  by_cases h : s = t
  · subst h
    simp
  · have ht : t ≠ s := fun hts => h hts.symm
    simp [pairWeight_of_ne h, pairWeight_of_ne ht]

/-- The spin observable squares to one. -/
@[simp] theorem spinValue_mul_self (s : Spin) :
    spinValue s * spinValue s = 1 := by
  cases s <;> simp [spinValue]

/-- Local Boltzmann weights are exactly the corresponding entries of the
zero-field Ising transfer matrix. -/
theorem pairWeight_eq_isingTransferMatrix_entry (β : ℝ) (s t : Spin) :
    pairWeight β s t = (isingTransferMatrix β).entry s t := by
  cases s <;> cases t <;>
    simp [pairWeight, Matrix2.entry, isingTransferMatrix, transferMatrix,
      alignedWeight, antiAlignedWeight]

/-- The full periodic configuration weight is a product of transfer-matrix
entries. -/
theorem pairWeight_product_eq_transferMatrix_entry_product
    (β : ℝ) (n : ℕ) (σ : Fin (n + 1) → Spin) :
    (∏ i : Fin (n + 1), pairWeight β (σ i) (σ (i + 1)))
      = ∏ i : Fin (n + 1),
          (isingTransferMatrix β).entry (σ i) (σ (i + 1)) := by
  apply Finset.prod_congr rfl
  intro i _
  exact pairWeight_eq_isingTransferMatrix_entry β (σ i) (σ (i + 1))

/-- The first-principles partition function after the local transfer-entry
rewrite, before proving that the configuration sum is the trace. -/
theorem gibbsPartition_eq_transferMatrix_entry_sum (β : ℝ) (n : ℕ) :
    gibbsPartition β n
      = ∑ σ : Fin (n + 1) → Spin,
          ∏ i : Fin (n + 1),
            (isingTransferMatrix β).entry (σ i) (σ (i + 1)) := by
  simp [gibbsPartition, pairWeight_eq_isingTransferMatrix_entry]

/-- The closed trace formula specialized to the zero-field Ising transfer
matrix, in the exact notation used by the Gibbs frontier. -/
theorem trace_isingTransferMatrix_pow (β : ℝ) (n : ℕ) :
    ((isingTransferMatrix β).pow n).trace
      = isingLambdaPlus β ^ n + isingLambdaMinus β ^ n := by
  simpa [isingTransferMatrix, isingLambdaPlus, isingLambdaMinus] using
    trace_transferMatrix_pow (alignedWeight β) (antiAlignedWeight β) n

/-- The one-step trace expansion in the exact transfer matrix used by the
Gibbs frontier. -/
theorem trace_isingTransferMatrix_pow_succ_eq_entry_sum (β : ℝ) (n : ℕ) :
    ((isingTransferMatrix β).pow (n + 1)).trace
      = ∑ s : Spin, ∑ t : Spin,
          ((isingTransferMatrix β).pow n).entry s t
            * (isingTransferMatrix β).entry t s := by
  exact Matrix2.trace_pow_succ_eq_entry_sum (isingTransferMatrix β) n

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
