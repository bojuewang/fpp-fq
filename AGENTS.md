# Research instructions for agents

These instructions govern work throughout the repository. Follow the [research protocols](protocols/) and place each artifact according to the [architecture](ARCHITECTURE.md).

## Mathematical claims

- Use established terminology and the repository's [notation](protocols/notation.md). State the base field, hypotheses, and equivalence relation wherever they affect the claim.
- Identify each substantive claim as an **assumption**, **conjecture**, **computation**, or **proved result**. For a proof, give the argument or a checked citation with the precise statement and explain how its hypotheses hold. For a computation, state exactly what the calculation established.
- Attribute a classification or uniformization theorem only within its stated scope. Record bidisk uniformization for a fake quadric only when the individual construction or an applicable theorem establishes it.
- Check citations against the original source. Cite the theorem, table, or section where possible. Never fabricate a citation, surface, execution, certificate, or outcome. Represent missing information according to the [data protocol](protocols/data.md).

## Computation and verification

Use Magma or Wolfram Mathematica for mathematical computations. Use exact arithmetic whenever certifying a statement. Record any role played by numerical exploration and supply an exact argument for the asserted result. Attempt independent verification where feasible, for example by checking a certificate in the other engine or proving the criterion directly.

Record the following details for every substantive computation.

| Required item | Details |
| --- | --- |
| Input | Surface or experiment identifier, script path and revision, input files or exact values, and checksums for external data. |
| Output | Exact result or a path and checksum for a retained artifact. Record failures and partial results. |
| Software version | Engine, version, and interface used. |
| Execution command | A replayable command with the working directory, parameters, and any seed that affects the run. |
| Assumptions | Field, precision or exact arithmetic mode, hypotheses, and dependencies on earlier claims. |
| Verification status | Which claims were checked, method, outcome, evidence path, and any outstanding independent checks. |

Store the record alongside the experiment or in the surface's verification directory. Update the metadata when its evidence changes. Report a smoke test as passed only after successful execution and inspection of its required output. [Verification](protocols/verification.md) · [Reproducibility](protocols/reproducibility.md)

## Data, code, and progress

- Preserve original research data and provenance. Write derived artifacts separately and record their transformation. Retain the input and output history needed to reproduce a superseded result.
- Keep family-specific records in their branch. Reference shared definitions, schemas, and computational libraries by relative links or paths. Keep large intermediate files and local logs outside the tracked research record.
- Link substantive progress to the question, run record, source revision, and any resulting proof or certificate. Note unresolved assumptions or failed checks in the research report. Revise conclusions when evidence changes.
- Inspect the staged diff and file list before committing. Keep credentials, activation and license files, account-specific paths, confidential inputs, and unrelated work out of Git. Respect existing history and repository visibility.
