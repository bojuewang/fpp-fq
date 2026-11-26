# Reproducing a computation

Run a saved Magma or Wolfram Language source file from the recorded working directory. Capture the full engine version. Use repository-relative paths in shared records and keep executable overrides and local logs outside version control. A notebook computation should replay from a fresh kernel with all its inputs identified.

Attach the following record to each substantive computation in its experiment or surface directory.

| Record | What to supply |
|---|---|
| Question and assumptions | State the claim tested, hypotheses, coefficient domain, conventions and scope. |
| Inputs | Cite source files, exact data, digests, parameters and any random seed. |
| Software | Give the engine, version and any platform-dependent settings relevant to the result. |
| Command | Include the working directory, literal replay command and repository revision of its code and inputs. |
| Output | Preserve the exact result or a path with its content digest, exit status and any material diagnostics. |
| Verification | Give the verification status, checker or proof, expected result and any independent reproduction. |

Replay from the recorded revision in a clean checkout. Compare exact values, or compare a digest when the output has a documented deterministic byte representation. If a run is blocked, record the failure and the missing dependency. Keep reviewable certificates in [certificate storage](../data/certificates/).

## Reproduce the checkout

After private publication, run this block in Bash while authenticated to GitHub as the repository owner. It reuses an existing project checkout at `~/FPP-FQ`. The root check prevents Git from selecting a repository in a parent directory.

```bash
(
  set -eu
  project="$(gh api user --jq .login)/fpp-fq"
  workspace="$HOME/FPP-FQ"
  if [[ ! -e "$workspace/.git" ]]; then
    gh repo clone "$project" "$workspace"
  fi
  cd -- "$workspace"
  [[ "$(git rev-parse --show-toplevel)" == "$(pwd -P)" ]]
  remote_project=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
  [[ "${remote_project,,}" == "${project,,}" ]]
  bash tests/check-workspace.sh --tracked
  status=0
  bash scripts/research.sh check || status=1
  bash scripts/research.sh test all || status=1
  exit "$status"
)
```

To replay the current committed revision separately, clone it into a fresh temporary directory. The printed path identifies the checkout used for the test.

```bash
(
  set -eu
  cd -- "$HOME/FPP-FQ"
  [[ "$(git rev-parse --show-toplevel)" == "$(pwd -P)" ]]
  revision=$(git rev-parse --verify 'HEAD^{commit}')
  replay_dir=$(mktemp -d)
  git clone --no-local --no-checkout . "$replay_dir"
  cd -- "$replay_dir"
  git switch --detach "$revision"
  printf 'Checkout %s at %s\n' "$(pwd -P)" "$revision"
  bash tests/check-workspace.sh --tracked
  bash scripts/research.sh test all
)
```
