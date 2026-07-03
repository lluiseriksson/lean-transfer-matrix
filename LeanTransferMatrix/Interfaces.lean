import LeanTransferMatrix.Finite

/-!
# Import-facing transfer-matrix interface

The parent Yang-Mills assembly should import this file, not the model-specific files.
-/

namespace LeanTransferMatrix

/--
The explicit hypotheses needed by the parent project to translate between transfer spectral gap
and exponential clustering. No field is an axiom: each must be supplied by a downstream
construction of the relevant transfer operator.
-/
structure TransferOperatorInterface where
  /-- The finite-dimensional transfer data exposed to the parent assembly. -/
  data : FiniteTransferData
  /-- Forward transfer theorem, kept as an explicit hypothesis at the frontier. -/
  gapToClusteringHypothesis :
    HasStrictSpectralGap data → HasExponentialClustering data
  /-- Reverse transfer theorem, kept as an explicit hypothesis at the frontier. -/
  clusteringToGapHypothesis :
    HasUniformExponentialClustering data → HasStrictSpectralGap data

/--
Interface theorem: transfer spectral gap implies exponential clustering, conditional on the
explicit finite-dimensional transfer hypothesis packaged in `TransferOperatorInterface`.
Reference: Levin, Peres, and Wilmer (2009), *Markov Chains and Mixing Times*, Theorems 12.3-12.4.
-/
theorem gap_implies_clustering
    (I : TransferOperatorInterface)
    (hgap : HasStrictSpectralGap I.data) :
    HasExponentialClustering I.data :=
  I.gapToClusteringHypothesis hgap

/--
Interface theorem: uniform exponential clustering implies a transfer spectral gap, conditional on
the explicit finite-dimensional reverse-transfer hypothesis packaged in `TransferOperatorInterface`.
Reference: Levin, Peres, and Wilmer (2009), *Markov Chains and Mixing Times*, Theorems 12.3-12.4.
-/
theorem clustering_implies_gap
    (I : TransferOperatorInterface)
    (hcluster : HasUniformExponentialClustering I.data) :
    HasStrictSpectralGap I.data :=
  I.clusteringToGapHypothesis hcluster

end LeanTransferMatrix
