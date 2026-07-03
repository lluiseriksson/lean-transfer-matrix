# lean-transfer-matrix

Satellite Lean 4 + Mathlib repository for the THE-ERIKSSON-PROGRAMME.

This repo formalizes a small, honest transfer-matrix dictionary:

* lattice measure / finite model data -> transfer operator data;
* transfer spectral gap -> exponential two-point clustering;
* exponential clustering -> lower bound on transfer gap, when the finite transfer reconstruction hypothesis is supplied.

## Scope disclaimer

This is not a proof of the Yang-Mills mass gap. It does not prove reflection positivity, Osterwalder-Schrader reconstruction, a gauge-field transfer operator, Balaban estimates, or Kotecky-Preiss cluster expansion hypotheses. Those must enter as explicit imported hypotheses from the appropriate satellite repos.

The current `main` branch contains no `sorry`. Frontier statements with `sorry` belong on `frontier/*` branches and must be reflected in `HYPOTHESIS_FRONTIER.md`.

## Toolchain

The toolchain and Mathlib lock are copied from `github.com/lluiseriksson/THE-ERIKSSON-PROGRAMME` as of 2026-07-03:

* Lean: `leanprover/lean4:v4.29.0-rc6`
* Mathlib: `07642720480157414db592fa85b626dafb71355b`

## Milestones

* M0: zero-field one-dimensional Ising transfer matrix, explicit two-vector diagonalization, and correlation ratio formula. Closed without `sorry`.
* M1: finite-dimensional forward interface, currently hypothesis-explicit pending Perron-Frobenius/spectral-decomposition formalization.
* M2: finite-dimensional reverse interface, currently hypothesis-explicit.
* M3: discrete Gaussian chain, not started.

## Build

```bash
lake exe cache get
lake build
```
