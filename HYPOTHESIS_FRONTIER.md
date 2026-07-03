# Hypothesis Frontier

Date: 2026-07-03

## Lean `sorry` count

`main`: 0

No `axiom` declarations are present.

## Explicit hypotheses currently carried

The public interface packages the following hypotheses in `TransferOperatorInterface`:

* `gapToClusteringHypothesis : HasStrictSpectralGap data -> HasExponentialClustering data`
* `clusteringToGapHypothesis : HasUniformExponentialClustering data -> HasStrictSpectralGap data`

These are not asserted globally. They must be supplied by whichever construction identifies a concrete finite transfer operator and proves the relevant spectral/correlation estimates.

## Honest distance to the programme target

Closed now:

* M0 algebra for the zero-field 1D Ising 2x2 transfer matrix.
* A compilable parent-facing interface for the pair `gap <-> clustering`, with all missing mathematics exposed as parameters.

Still missing:

* Perron-Frobenius theorem strong enough for primitive nonnegative self-adjoint finite matrices.
* Spectral decomposition estimate on the centered two-point sector with exact rate `-log (lambda2 / lambda1)`.
* Reverse implication from uniform clustering to a gap lower bound in the finite framework.
* Discrete Gaussian chain transfer-operator model.
* Any gauge-field transfer-operator construction.
* Reflection positivity and OS reconstruction, deliberately out of scope here.
* Balaban `hRpoly`/`hg` and Kotecky-Preiss hypotheses, deliberately out of scope here.

## Frontier branch policy

Statements-first work with `sorry` should happen on branches named `frontier/*`.
Every such branch must update this file with:

* exact theorem names containing `sorry`;
* every explicit hypothesis introduced;
* whether the statement is intended for upstream Mathlib.
