#!/usr/bin/env bash
# Check the published layout and the relative Markdown links used for navigation.
set -eu
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
root=$(pwd -P)
tracked=false
case "${1:-}" in
    --tracked) tracked=true ;;
    '') ;;
    *) echo "Usage: bash tests/check-workspace.sh [--tracked]" >&2; exit 2 ;;
esac

if "$tracked" && [[ $(git rev-parse --show-toplevel) != "$root" ]]; then
    echo 'The project must have its own Git index for --tracked.' >&2
    exit 1
fi

errors=0
check_path() {
    local path=$1
    if [[ ! -e "$path" ]]; then
        printf 'Missing: %s\n' "$path" >&2
    elif ! "$tracked" || git ls-files --error-unmatch -- "$path" >/dev/null 2>&1; then
        return
    else
        printf 'Absent from the project index: %s\n' "$path" >&2
    fi
    errors=$((errors + 1))
}

for path in README.md AGENTS.md ARCHITECTURE.md ROADMAP.md CHANGELOG.md .gitignore .gitattributes \
    .vscode/{settings,tasks,extensions}.json \
    {fpp,fq}/{README.md,classification,database/registry.json,surfaces,equations,groups,automorphisms,coverings,commensurability,verification,experiments,literature} \
    shared/{theory,definitions,theorems,conjectures,algorithms,schemas/surface.schema.json,notation} \
    computational/{README.md,magma/{README.md,lib,scripts,tests,examples},mathematica/{README.md,packages,scripts,notebooks,tests,examples}} \
    data/{raw,processed,generated,certificates} \
    protocols/{README,terminology,notation,naming,data,research,verification,reproducibility}.md \
    docs/{architecture,diagrams,mathematical,computational} \
    scripts/research.sh tests references reports logs; do
    check_path "$path"
done

# The homepage uses ordinary inline links with repository-relative destinations.
while IFS= read -r link; do
    path=${link#*](}
    path=${path%)}
    path=${path%%#*}
    case "$path" in
        ''|*://*|mailto:*) continue ;;
    esac
    check_path "$path"
done < <(grep -oE '\[[^]]+\]\([^)]+\)' README.md)

if [[ $(grep -Fxc '```mermaid' README.md) -lt 2 ]] ||
    ! grep -Fxq '## Architectural principle' README.md ||
    ! grep -Fxq '**Independent research branches. Shared mathematical foundations. Unified computational infrastructure.**' README.md; then
    echo 'Missing homepage heading, architectural principle, or Mermaid blocks.' >&2
    errors=$((errors + 1))
fi
if (( errors > 0 )); then exit 1; fi
if "$tracked"; then
    echo 'PASS: required layout and homepage link destinations exist in the project index.'
else
    echo 'PASS: required layout and homepage link destinations exist in the working tree.'
fi
