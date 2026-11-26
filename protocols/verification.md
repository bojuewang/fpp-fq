# Verification

For each claim, record the proposition, its hypotheses, the check performed and the supporting proof, source or certificate. Name the exact arithmetic domain for a certified computation. For numerical evidence, give the precision, error criterion and scope of the observation.

Try an independent derivation or a separately written checker when feasible. For example, reconstruct a polynomial from published coefficients in one engine and check its exact substitution in the other. State what is common to the two checks, such as the same coordinate transcription.

| Metadata status | Evidence needed |
|---|---|
| `unverified` | The record identifies its source or purpose and awaits a check of its claims. |
| `partially-verified` | A documented check supports some populated claims. Identify what still needs a check. |
| `verified` | Every asserted mathematical value has a documented check or cited proof with its hypotheses matched. List the checked fields and the limits of verification. An explicitly unknown field carries no claim. |
| `disputed` | Evidence conflicts with at least one assertion. Identify the field, conflicting sources or outputs, and the unresolved discrepancy. |

Store a replayable witness or exact checker output under [certificates](../data/certificates/) or the surface's verification directory. Include the goal, input hash and checker invocation. A successful smoke test establishes only the exact identity it checks.
