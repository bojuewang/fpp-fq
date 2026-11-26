# Computational infrastructure

Both research branches use [Magma](magma/) and [Mathematica](mathematica/). Shared code belongs in `magma/lib/` or `mathematica/packages/`. A branch-specific computation can call a shared routine and record the input, output, version, command, assumptions and verification status alongside the surface or experiment.

Open the project in **VS Code connected to WSL**. Use **Tasks: Run Task** for environment inspection, current-file execution or smoke tests. Task arguments preserve spaces in workspace and file paths. The same commands run at the repository root in Bash.

```bash
bash scripts/research.sh check
bash scripts/research.sh test all
```

The environment check prints local executable paths and versions to the terminal. It returns a nonzero status when a required tool is missing or a Wolfram kernel cannot start. Each smoke test requires a zero process exit and its own success marker. The combined task attempts both tests. A missing engine returns 127, a failed smoke test returns 1, and a successful suite returns 0.

For an installation outside the search path, export `MAGMA_BIN` or `WOLFRAM_BIN` in the environment inherited by the WSL terminal or VS Code task process. Each variable holds one executable path, including any spaces. Keep local paths and environment reports private.
