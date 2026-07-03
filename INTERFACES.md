# Interfaces

The parent project should import:

```lean
import LeanTransferMatrix.Interfaces
```

## Stable exported objects

```lean
structure LeanTransferMatrix.FiniteTransferData where
  lambda1 : Real
  lambda2 : Real
  amplitude : Real
  correlation : Nat -> Real
```

```lean
def LeanTransferMatrix.HasStrictSpectralGap
    (D : LeanTransferMatrix.FiniteTransferData) : Prop
```

```lean
def LeanTransferMatrix.HasExponentialClustering
    (D : LeanTransferMatrix.FiniteTransferData) : Prop
```

```lean
def LeanTransferMatrix.HasUniformExponentialClustering
    (D : LeanTransferMatrix.FiniteTransferData) : Prop
```

```lean
structure LeanTransferMatrix.TransferOperatorInterface where
  data : LeanTransferMatrix.FiniteTransferData
  gapToClusteringHypothesis :
    LeanTransferMatrix.HasStrictSpectralGap data ->
      LeanTransferMatrix.HasExponentialClustering data
  clusteringToGapHypothesis :
    LeanTransferMatrix.HasUniformExponentialClustering data ->
      LeanTransferMatrix.HasStrictSpectralGap data
```

```lean
theorem LeanTransferMatrix.gap_implies_clustering
    (I : LeanTransferMatrix.TransferOperatorInterface)
    (hgap : LeanTransferMatrix.HasStrictSpectralGap I.data) :
    LeanTransferMatrix.HasExponentialClustering I.data
```

```lean
theorem LeanTransferMatrix.clustering_implies_gap
    (I : LeanTransferMatrix.TransferOperatorInterface)
    (hcluster : LeanTransferMatrix.HasUniformExponentialClustering I.data) :
    LeanTransferMatrix.HasStrictSpectralGap I.data
```

## Breaking-change policy

Changing any signature in this file is a breaking change for the mother repo and must be announced in the corresponding PR.
