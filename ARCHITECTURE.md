# Repository architecture

## Where a result belongs

A surface identifier ties its equations, group computations, and verification records to one directory. A mathematical statement used by both families has one home in the shared knowledge base. A routine used by several experiments has one implementation per computational engine.

| Location | Contents and links |
| --- | --- |
| [FPP](fpp/) and [FQ](fq/) | Parallel subject directories. Each branch owns its classification notes, registry, individual surfaces, equations, groups, automorphisms, coverings, commensurability, verification, experiments, and literature. |
| [Shared mathematics](shared/) | Definitions and notation establish meaning. Theory and theorems hold arguments and their hypotheses. Conjectures identify open claims. Algorithms describe mathematical procedures. Schemas specify their data formats. |
| [Magma](computational/magma/) and [Mathematica](computational/mathematica/) | Magma libraries and Wolfram packages hold reusable procedures. Scripts run them on stated inputs. Engine-specific tests exercise them. Mathematica notebooks may accompany a script or document an experiment. |
| [Scripts](scripts/), [tests](tests/), and [VS Code](.vscode/) | Shell commands and editor tasks invoke the engines. Repository-level checks cover structure and integration. |
| [Data](data/) | Raw sources, processed representations, generated outputs, and portable verification certificates. |
| [Protocols](protocols/) and [documentation](docs/) | Protocols define research practice. Extended architectural notes, diagrams, mathematical exposition, and computational guides belong in the corresponding documentation directories. |
| [References](references/), [reports](reports/), and [logs](logs/) | Shared bibliographic records, dated accounts of research, and local run output, respectively. |

## Following a surface from source to result

1. Identify the surface in a primary source. Assign its repository identifier and record external classification labels with their sources. Index the identifier in its family registry. [FPP registry](fpp/database/registry.json) · [FQ registry](fq/database/registry.json)
2. Use the surface directory template. Keep the canonical metadata at `<family>/surfaces/<surface-id>/metadata.json`. Record unknown fields explicitly using the common schema. [Surface template and data conventions](protocols/data.md) · [Surface schema](shared/schemas/surface.schema.json)
3. Preserve the input in `data/raw/` with its provenance, or cite a retrievable source and checksum when the input cannot be distributed. Document each transformation into `data/processed/`. Record the coefficient field, ordered variables, and basis or embedding whenever they affect interpretation.
4. Put a surface-specific computation with its surface. Call shared Magma libraries or Wolfram packages by repository-relative paths. Write transient outputs under `data/generated/`. Include the command and exact input needed to regenerate them in the run record. [Computational guide](computational/README.md)
5. Put the claim and its supporting evidence in the surface's `verification/` directory. Link reusable certificate data from `data/certificates/`, then link the evidence from the surface metadata and any report that uses the claim. [Verification protocol](protocols/verification.md)

Family-level files may compare multiple surfaces or explain a method specific to that family. They link to the individual records for equations, fields, and evidence. Changes to shared definitions belong in [shared/definitions](shared/definitions/), and changes to conventions belong in [protocols](protocols/).

## Local and version-controlled material

Track mathematical sources, reviewed data, notebooks, and certificates needed to reproduce results. Keep executable overrides, activation information, execution logs, caches, and large intermediate data local. A `.gitkeep` marks an intended empty directory. [Ignore rules](.gitignore) · [Reproducibility protocol](protocols/reproducibility.md)
