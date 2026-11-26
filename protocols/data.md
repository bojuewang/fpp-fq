# Surface data and directory template

The two registries are JSON arrays of stable IDs. For each ID in a registry, the branch contains exactly one `surfaces/<surface-id>/metadata.json`. An empty registry means that the branch has no catalogued records. Add the ID, its directory and its provenance in one change. [FPP registry](../fpp/database/registry.json) · [FQ registry](../fq/database/registry.json) · [Surface schema](../shared/schemas/surface.schema.json)

```text
surfaces/<surface-id>/
├── README.md
├── metadata.json
├── equations/
├── groups/
├── coverings/
├── computations/
├── verification/
└── references/
```

The README identifies the surface and its equivalence convention. Give its original designation, source and locator. For each populated mathematical field, identify the supporting statement, derivation or computation. Explain any unsupported, inapplicable or conflicting claims there. Place local evidence in the matching subdirectory and link to shared artifacts when several surfaces use them.

## Reading metadata

| Field or group | Convention |
|---|---|
| Identity | Use an assigned `surface_id`, `FPP` or `FQ` for `family`, and a current `verification_status`. These three keys have explicit values in every record. |
| Missing information | Include all schema keys. Use JSON `null` for an unknown value. A known empty collection uses `[]`. For a list of attached references or certificates, an empty array means the record has none attached. |
| Numerics | `euler_characteristic` is $e(X)$. List `betti_numbers` in degrees 0 through 4. Write `first_integral_homology` as invariant factors $d_i>1$ with $d_i\mid d_{i+1}$, so that $H_1$ is the direct sum of $\mathbb Z/d_i\mathbb Z$. Its free rank is zero for both families. |
| Groups, cover, field, embedding | Give a `description` and optionally an `artifact` path to exact data. Describe the action for a lattice, generators and relators for a group presentation, and the ambient space and linear system for a projective embedding. Mark a proved inapplicability in the description with its reason. |
| Equations and matrix | Use repository-root-relative paths to versioned data. Resolve coordinates, field generators and coefficient bases through the same record. |
| Covering relationships | Record the source, target and a description of each map. Use the local ID for a registered surface and a source-qualified name for an external object. Give the finite degree when known. |
| References, evidence and status | Each reference identifies the work and a precise locator. Certificate paths resolve from the repository root. State which fields each reference or certificate supports. Set the record status using the [verification protocol](verification.md). |

## Exact data interchange

Store original inputs with provenance in [raw data](../data/raw/). Preserve their bytes and put transcriptions or normalizations in [processed data](../data/processed/). Record a checksum of the original, the transformation and the resulting artifact. When redistribution is restricted, record the citation, retrieval procedure and checksum.

Use JSON for portable mathematical data. For a rational coefficient, store an exact reduced numerator and positive denominator, each as a signed or unsigned decimal integer string as appropriate. For an algebraic number, specify its defining field, generator and ordered rational basis, then store its coefficient vector in that basis. Identify the complex embedding if a root choice affects the result.

In a sparse polynomial, pair each coefficient with its nonnegative exponent vector in the declared variable order. For a coefficient matrix, record dimensions, row and column meanings, monomial order, coefficient field and entries by row. Reconstructing the polynomials from the matrix gives a check on the transcription.
