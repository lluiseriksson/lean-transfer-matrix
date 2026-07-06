# Status

Last refreshed: 2026-07-06T16:08Z.

This file is an operational heartbeat for `THE-ERIKSSON-PROGRAMME`
consumers. It adds no Lean declarations and makes no new mathematical claim.

## Current main

Default branch: `main`

Checked head: `1a987a049594f85f8ef137978c5f5c5ededd8040`

Latest checked runs on that head:

* `CI`: success, run
  `28801139572`
  (`https://github.com/lluiseriksson/lean-transfer-matrix/actions/runs/28801139572`).
* `heartbeat`: success, run
  `28801139421`
  (`https://github.com/lluiseriksson/lean-transfer-matrix/actions/runs/28801139421`).

The stable parent-facing import remains:

```lean
import LeanTransferMatrix.Interfaces
```

For the closed zero-field one-dimensional Ising witness, use:

```lean
import LeanTransferMatrix.Ising1DGap
```

For the finite-window extraction guardrail contract, use:

```lean
import LeanTransferMatrix.FiniteWindowExtraction
```

## Stable API names

The current main-branch names intended for mother-facing consumption are:

* `LeanTransferMatrix.FiniteTransferData`
* `LeanTransferMatrix.HasStrictSpectralGap`
* `LeanTransferMatrix.HasExponentialClustering`
* `LeanTransferMatrix.HasUniformExponentialClustering`
* `LeanTransferMatrix.TransferOperatorInterface`
* `LeanTransferMatrix.gap_implies_clustering`
* `LeanTransferMatrix.clustering_implies_gap`
* `LeanTransferMatrix.FiniteWindowExtractionData`
* `LeanTransferMatrix.FiniteWindowExtractionHypotheses`
* `LeanTransferMatrix.FiniteWindowExtractionRejectsInvertedRegime`
* `LeanTransferMatrix.finiteWindowExtractionRejectsInvertedRegime`

See `INTERFACES.md` and `MOTHER_DIGEST.md` for the exact field and theorem
shapes.

## Live work

Open frontier PR:

* `#8` (`[codex] link Gibbs weights to transfer entries`) targets
  `frontier/M1`, not `main`.

Open agent tasks:

* `#4` (`M1: cerrar gibbsPartition_eq_trace`) tracks the next frontier
  proof target.

No open `blocked` or `interface-change` issue was found during this refresh.

## Next exact step

Continue the frontier-only reduction of
`LeanTransferMatrix.Ising1D.gibbsPartition_eq_trace` on `frontier/M1`.
Do not import frontier declarations into the mother repo until the relevant
proofs are closed or an explicit `interface-change` issue carries the
hypotheses.
