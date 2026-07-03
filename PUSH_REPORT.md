# Informe de sesión — lean-transfer-matrix (empuje M1)

## Plantilla §B2

```
HECHO:
  Rama push/m1-ising-closure (candidato a main, 0 sorry, 0 axiom):
    Ising1DGap.lean — gap bilateral |λ₋| < λ₊ para todo β; ratio = tanh β;
      HasStrictSpectralGap, HasExponentialClustering (amplitud 1, ratio
      exacto) y HasUniformExponentialClustering PROBADOS para la cadena de
      Ising ferromagnética; isingInterface = PRIMERA instancia de
      TransferOperatorInterface con CERO hipótesis cargadas.
    RateGlue.lean — exponentialRate_pos (la tasa -log(λ₂/λ₁) es un mass gap
      positivo); spectralRatio_pow_eq_exp y clustering_exp_form: el clustering
      en la forma amplitude·exp(-rate·n) que consume el ensamblaje M3 del
      madre.
    Matrix2Algebra.lean — Matrix2.{ext,mul,one,pow,trace};
      transferMatrix_pow (forma cerrada espectral de T^n por inducción);
      Z_n = λ₊^n + λ₋^n; eigenrelaciones de todas las potencias.
    HYPOTHESIS_FRONTIER.md actualizado. Barrel actualizado.
  Rama frontier/M1 (statements-first, sorried, NUNCA a main):
    Frontier/PerronFrobenius.lean — exists_perron_pair,
      eigenvalue_le_perron, eigenvalue_lt_perron_of_orthogonal,
      centered_power_bound (candidato a upstream Mathlib).
    Frontier/GibbsChain.lean — gibbsPartition_eq_trace, gibbsTwoPoint_eq,
      gibbsCorrelation_tendsto: la medida de Gibbs desde primeros principios,
      cerrando el hueco de honestidad declarado en T0.
SIGUIENTE: verificar CI en push/m1-ising-closure; después
  gibbsPartition_eq_trace (inducción sobre la cadena) como unidad mínima —
  es la que retroactivamente justifica isingTwoPointCorrelation.
BLOQUEOS: ninguno.
IMPACTO-INTERFAZ: no (Interfaces.lean intacto). Cuando el madre quiera
  consumir isingInterface o clustering_exp_form, ritual Interface-Change.
HONESTIDAD: (1) NINGÚN enunciado debilitado; isingInterface exige 0 ≤ β
  (régimen ferromagnético), condición declarada en la firma, no escondida.
  (2) Empuje escrito SIN build local de Mathlib (3 GB RAM / 10 GB disco del
  contenedor vs ~10 GB de oleans); el CI es el juez: push/m1-ising-closure NO
  toca main sin heartbeat verde. (3) centered_power_bound lleva ∃C ∃ρ en vez
  de constantes explícitas: compromiso temporal declarado en el docstring.
```

## Cómo aplicar

```bash
git fetch origin
git checkout -b push/m1-ising-closure origin/main
git am 0001-*.patch
git push -u origin push/m1-ising-closure     # CI juzga; si verde → PR a main
git checkout -b frontier/M1
git am 0002-*.patch
git push -u origin frontier/M1
```

## VERIFICATION.md — puntos de riesgo del primer build (orden de probabilidad)

1. `Real.tanh_eq_sinh_div_cosh` / `Real.sinh_eq` / `Real.cosh_eq`: si algún
   nombre difiere en el pin, localizar con
   `grep -rn "tanh" .lake/packages/mathlib/Mathlib/Analysis/SpecialFunctions/Trigonometric/Basic.lean`.
   El `field_simp` final de isingSpectralRatio_eq_tanh puede necesitar un
   `ring` a continuación.
2. Los `rw [..., one_mul]` de Ising1DGap terminan en `exact le_rfl`; si algún
   reescrito no casa sintácticamente (proyecciones de isingTransferData),
   sustituir el rw por `show |isingSpectralRatio β ^ n| ≤ 1 * isingSpectralRatio β ^ n`
   antes de reescribir.
3. `intro n` sobre `HasExponentialClustering` y `refine ⟨...⟩` sobre
   `HasUniformExponentialClustering` dependen de que el def se despliegue en
   whnf; si no, anteponer `unfold HasExponentialClustering` /
   `unfold HasUniformExponentialClustering`.
4. `Real.exp_nat_mul` (exp (n·x) = exp x ^ n) y `Real.exp_log`: nombres
   estables, pero si exp_nat_mul cambió de orden de argumentos, usar
   `Real.exp_natCast_mul` o reescribir vía `Real.rpow`.
5. En `transferMatrix_pow`, el `show` del caso succ usa la ecuación de
   pattern-matching de `Matrix2.pow`; si el elaborador protesta, sustituir
   por `rw [Matrix2.pow]`.
6. `simp_all` en `Matrix2.ext` tras `cases`: si deja metas, sustituir por
   `subst h1; subst h2; subst h3; subst h4; rfl`.
7. Frontier: `import Mathlib` global — solo compila en la rama frontier con
   la cache completa; es deliberado y está documentado en los docstrings.

## Qué gana el madre con este empuje

El diccionario gap ⇔ clustering deja de ser un par de hipótesis vacías: existe
un modelo real donde ambas direcciones son teoremas con constantes exactas
(C = 1, ρ = tanh β, tasa = -log tanh β > 0). Y clustering_exp_form entrega el
decaimiento exactamente en la forma amplitude·exp(-rate·n) que el ensamblaje
M3 del madre usa para enunciar el mass gap, con la positividad de la tasa
probada, no supuesta.
