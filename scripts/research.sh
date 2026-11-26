#!/usr/bin/env bash
# Computational entry point for a Linux or VS Code WSL workspace.
set -u
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P) || exit 1

locate_magma() {
    local candidate
    for candidate in "${MAGMA_BIN:-magma}" magma.exe /opt/magma*/magma /usr/local/magma*/magma; do
        magma_path=$(type -P -- "$candidate") && return 0
        [[ -z ${MAGMA_BIN:-} ]] || break
    done
    printf 'BLOCKED Magma executable unavailable. Set MAGMA_BIN to the installed launcher.\n' >&2
    return 127
}

# Give Windows programs a drive or UNC path. Magma also ships ELF binaries named *.exe.
engine_path() {
    if [[ ${1,,} == *.exe && $(head -c 2 -- "$1") == MZ ]]; then
        wslpath -aw "$2"
    else
        realpath -- "$2"
    fi
}

wolfram_candidates() {
    if [[ -n ${WOLFRAM_BIN:-} ]]; then
        printf '%s\n' "$WOLFRAM_BIN"
    else
        printf '%s\n' wolframscript wolframscript.exe WolframKernel MathKernel WolframKernel.exe MathKernel.exe
        local path
        for path in /mnt/?/'Program Files/Wolfram Research'/WolframScript/wolframscript.exe \
                    /mnt/?/'Program Files/Wolfram Research'/{Wolfram,Mathematica,'Wolfram Engine'}/*/{wolframscript,WolframKernel,MathKernel}.exe; do
            [[ -x $path ]] && printf '%s\n' "$path"
        done
    fi
}

select_wolfram() {
    local candidate probe output path
    local -A tried=()
    local version_code='Print["FPPFQ_VERSION ", $Version]'
    while IFS= read -r candidate; do
        path=$(type -P -- "$candidate") || continue
        [[ -z ${tried["$path"]+seen} ]] || continue
        tried["$path"]=1
        case "${path##*/}" in
            [Ww]olfram[Ss]cript|[Ww]olfram[Ss]cript.exe)
                wl_command=("$path" -local -file)
                probe=("$path" -local -code "$version_code")
                ;;
            WolframKernel|WolframKernel.exe|MathKernel|MathKernel.exe)
                wl_command=("$path" -noinit -noprompt -script)
                probe=("$path" -noinit -noprompt -run "$version_code; Quit[]")
                ;;
            *)
                printf 'Unsupported Wolfram launcher name: %s\n' "${path##*/}" >&2
                continue
                ;;
        esac
        output=$(timeout 30s "${probe[@]}" </dev/null 2>/dev/null) || continue
        wl_version=$(sed -n 's/^FPPFQ_VERSION //p' <<< "${output//$'\r'/}")
        [[ -n $wl_version ]] && return 0
    done < <(wolfram_candidates)
    printf 'BLOCKED No Wolfram interface started a local kernel. Check the installation or set WOLFRAM_BIN.\n' >&2
    return 127
}

report_cli() {
    local label=$1 path version
    shift
    path=$(type -P -- "$1") || { printf 'BLOCKED %s executable unavailable\n' "$label"; return 127; }
    version=$(timeout 10s "$path" "${@:2}" </dev/null 2>/dev/null) || version='version unavailable'
    printf '%s: %s (%s)\n' "$label" "$path" "${version%%$'\n'*}"
}

environment_report() {
    local status=0 candidate path version
    printf 'OS: %s\n' "$(uname -srm)"
    report_cli Git git --version || status=1
    report_cli 'VS Code' code --version || status=1
    if locate_magma; then
        version=$(timeout 10s "$magma_path" -V </dev/null 2>/dev/null) || version='version unavailable'
        printf 'Magma: %s (%s)\n' "$magma_path" "${version%%$'\n'*}"
    else
        status=1
    fi
    for candidate in wolframscript WolframKernel MathKernel wolframscript.exe WolframKernel.exe MathKernel.exe; do
        if path=$(type -P -- "$candidate"); then printf 'Wolfram interface on PATH: %s\n' "$path"; fi
    done
    if select_wolfram; then
        printf 'Mathematica: %s (kernel %s)\n' "${wl_command[0]}" "$wl_version"
    else
        status=1
    fi
    return "$status"
}

prepare_run() {
    local engine=$1 file=$2 path startup
    [[ -f $file && -r $file ]] || { printf 'Unreadable input: %s\n' "$file" >&2; return 2; }
    case "$engine" in
        magma)
            [[ $file == *.m ]] || { printf 'Expected a Magma .m file.\n' >&2; return 2; }
            locate_magma || return $?
            path=$(engine_path "$magma_path" "$file") || return 1
            startup=$(engine_path "$magma_path" "$root/computational/magma/scripts/batch.m") || return 1
            run_command=("$magma_path" -b -s "$startup" "$path")
            ;;
        mathematica)
            [[ $file == *.wl || $file == *.wls ]] || { printf 'Expected a Wolfram .wl or .wls script.\n' >&2; return 2; }
            select_wolfram || return $?
            path=$(engine_path "${wl_command[0]}" "$file") || return 1
            run_command=("${wl_command[@]}" "$path")
            ;;
        *) usage; return 2 ;;
    esac
}

smoke() {
    local engine=$1 file marker output rc=0
    case "$engine" in
        magma) file="$root/computational/magma/tests/smoke.m"; marker=MAGMA_SMOKE_TEST_OK ;;
        mathematica) file="$root/computational/mathematica/tests/smoke.wls"; marker=MATHEMATICA_SMOKE_TEST_OK ;;
        *) usage; return 2 ;;
    esac
    prepare_run "$engine" "$file" || return $?
    output=$(timeout 90s "${run_command[@]}" </dev/null 2>/dev/null) || rc=$?
    if [[ $rc == 0 ]] && grep -Fxq -- "$marker" <<< "${output//$'\r'/}"; then
        printf 'PASS %s\n' "$marker"
    else
        printf 'FAIL %s smoke test (exit %s, expected output line %s).\n' "$engine" "$rc" "$marker" >&2
        return 1
    fi
}

usage() {
    printf 'Usage: bash scripts/research.sh check | test {magma|mathematica|all} | run {magma|mathematica} FILE\n' >&2
}

case "${1:-}" in
    check) [[ $# == 1 ]] || { usage; exit 2; }; environment_report ;;
    run)
        [[ $# == 3 ]] || { usage; exit 2; }
        prepare_run "$2" "$3" || exit $?
        exec "${run_command[@]}" </dev/null
        ;;
    test)
        [[ $# == 2 ]] || { usage; exit 2; }
        if [[ $2 == all ]]; then
            magma_rc=0
            wolfram_rc=0
            smoke magma || magma_rc=$?
            smoke mathematica || wolfram_rc=$?
            if [[ $magma_rc == 1 || $wolfram_rc == 1 ]]; then exit 1; fi
            (( magma_rc == 0 )) || exit "$magma_rc"
            exit "$wolfram_rc"
        fi
        smoke "$2"
        ;;
    *) usage; exit 2 ;;
esac
