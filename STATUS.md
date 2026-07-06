# Status

Last refreshed: 2026-07-06.

This file is an operational heartbeat for `THE-ERIKSSON-PROGRAMME`
consumers. It adds no Lean declarations and makes no new mathematical claim.

## Current main

Default branch: `main`

Checked head: `d2eaa2e36462d72c9835fbe87b32a923276987d2`

Latest checked runs on that head:

* heartbeat: success, run
  `28768270113`
  (`https://github.com/lluiseriksson/lean-transfer-matrix/actions/runs/28768270113`).

No standalone `CI` workflow run was found on this exact head during this
refresh. The heartbeat workflow includes the main-branch build/sorry/axiom
check and was green.

The stable parent-facing import remains:

```lean
import LeanTransferMatrix.Interfaces
```

For the closed zero-field one-dimensional Ising witness, use:

```lean
import LeanTransferMatrix.Ising1DGap
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

See `INTERFACES.md` and `MOTHER_DIGEST.md` for the exact field and theorem
shapes.

## Live work

Open frontier PR:

* `#8` (`[codex] link Gibbs weights to transfer entries`) targets
  `frontier/M1`, not `main`.

Open agent tasks:

* `#4` (`M1: cerrar gibbsPartition_eq_trace`) tracks the next frontier
  proof target.
* `#9` (`Formalize 2602.0032 finite-window extraction guardrail`) tracks a
  mother-facing finite-window extraction guardrail interface or contract note.

No open `blocked` or `interface-change` issue was found during this refresh.

## Next exact step

Continue the frontier-only reduction of
`LeanTransferMatrix.Ising1D.gibbsPartition_eq_trace` on `frontier/M1`.
Do not import frontier declarations into the mother repo until the relevant
proofs are closed or an explicit `interface-change` issue carries the
hypotheses.
