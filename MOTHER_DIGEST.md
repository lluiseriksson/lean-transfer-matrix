# Mother-facing digest

Date: 2026-07-03

This note is an import-facing map for `THE-ERIKSSON-PROGRAMME`. It is only a
status/digest artifact: it adds no Lean declarations and makes no new
mathematical claim.

## Main branch import surface

Use `LeanTransferMatrix.Interfaces` for the parent-facing API.

Exact names:

* `LeanTransferMatrix.FiniteTransferData`
* `LeanTransferMatrix.HasStrictSpectralGap`
* `LeanTransferMatrix.HasExponentialClustering`
* `LeanTransferMatrix.HasUniformExponentialClustering`
* `LeanTransferMatrix.TransferOperatorInterface`
* `LeanTransferMatrix.gap_implies_clustering`
* `LeanTransferMatrix.clustering_implies_gap`

The interface is hypothesis-explicit. `TransferOperatorInterface` carries:

* `gapToClusteringHypothesis :
    HasStrictSpectralGap data -> HasExponentialClustering data`
* `clusteringToGapHypothesis :
    HasUniformExponentialClustering data -> HasStrictSpectralGap data`

These fields are ordinary structure data, not global declarations.

## Closed local model on main

The zero-field one-dimensional Ising model is the closed test model.

Files:

* `LeanTransferMatrix/Ising1D.lean`
* `LeanTransferMatrix/Matrix2Algebra.lean`
* `LeanTransferMatrix/Ising1DGap.lean`
* `LeanTransferMatrix/RateGlue.lean`

Useful exact names:

* `LeanTransferMatrix.Ising1D.isingTransferMatrix`
* `LeanTransferMatrix.Ising1D.isingLambdaPlus`
* `LeanTransferMatrix.Ising1D.isingLambdaMinus`
* `LeanTransferMatrix.Ising1D.isingSpectralRatio`
* `LeanTransferMatrix.Ising1D.isingTransferData`
* `LeanTransferMatrix.Ising1D.isingInterface`
* `LeanTransferMatrix.Ising1D.trace_transferMatrix_pow`
* `LeanTransferMatrix.FiniteTransferData.exponentialRate_pos`
* `LeanTransferMatrix.FiniteTransferData.clustering_exp_form`

Consumption pattern for the mother repo:

1. Import `LeanTransferMatrix.Interfaces` when only the abstract transfer
   dictionary is needed.
2. Import `LeanTransferMatrix.Ising1DGap` only for the closed Ising witness
   `isingInterface`.
3. Import `LeanTransferMatrix.RateGlue` when the consumer needs the
   `amplitude * exp (-rate * n)` form.

## Frontier not yet consumable

Frontier work lives off `main` on `frontier/*` branches and is tracked in
`HYPOTHESIS_FRONTIER.md`.

Current named frontier blockers:

* `LeanTransferMatrix/Frontier/PerronFrobenius.lean`:
  `exists_perron_pair`, `eigenvalue_le_perron`,
  `eigenvalue_lt_perron_of_orthogonal`, `centered_power_bound`.
* `LeanTransferMatrix/Frontier/GibbsChain.lean`:
  `gibbsPartition_eq_trace`, `gibbsTwoPoint_eq`,
  `gibbsCorrelation_tendsto`.

Do not consume these from the mother repo until they are complete proofs or
are explicitly carried as hypotheses by an interface-change issue.

## Next exact step

For the active frontier issue, continue reducing
`LeanTransferMatrix.Ising1D.gibbsPartition_eq_trace` on `frontier/M1`.
The current main branch remains the stable complete-proof import target.
