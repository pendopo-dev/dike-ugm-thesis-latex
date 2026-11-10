#!/usr/bin/env bash
# Build and assertion tests for the LaTeX template.
set -uo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
WORK=$(mktemp -d "${TMPDIR:-/tmp}/dike-template-tests.XXXXXX")
if [[ ${KEEP_TESTS:-0} == 1 ]]; then
    echo "test work directory: $WORK"
else
    trap 'rm -rf "$WORK"' EXIT
fi
failures=0

for command in pdflatex bibtex makeindex pdftotext python3 make; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "missing required command: $command" >&2
        exit 2
    fi
done

pass() {
    echo "  PASS: $1"
}

fail() {
    echo "  FAIL: $1" >&2
    return 1
}

run_test() {
    local name=$1
    shift
    echo "== $name"
    if "$@"; then
        pass "$name"
    else
        echo "  FAIL: $name" >&2
        failures=$((failures + 1))
    fi
}

copy_repo() {
    local destination=$1
    mkdir -p "$destination"
    (cd "$ROOT" && tar \
        --exclude=.git \
        --exclude=WORKER-REPORT.md \
        --exclude='*.aux' \
        --exclude='*.log' \
        --exclude='*.out' \
        --exclude='*.toc' \
        --exclude='*.lof' \
        --exclude='*.lot' \
        --exclude='*.nlo' \
        --exclude='*.nls' \
        --exclude='*.glo' \
        --exclude='*.gls' \
        --exclude='*.bbl' \
        --exclude='*.blg' \
        --exclude='template/proposal/main.pdf' \
        --exclude='template/skripsi/main.pdf' \
        -cf - .) | (cd "$destination" && tar -xf -)
}

build() {
    local repo=$1
    local target=$2
    local log=$3
    if ! (cd "$repo" && make "$target") >"$log" 2>&1; then
        echo "  make $target failed; last lines of $log:" >&2
        tail -n 30 "$log" | sed 's/^/    /' >&2
        return 1
    fi
    if [[ ! -f "$repo/template/$target/main.pdf" ]]; then
        fail "template/$target/main.pdf was not created"
        return 1
    fi
}

check_log() {
    local log=$1
    if grep -q '^! ' "$log"; then
        echo "  TeX errors in $log:" >&2
        grep -A2 '^! ' "$log" | head -20 | sed 's/^/    /' >&2
        return 1
    fi
    if grep -q 'Overfull \\hbox' "$log"; then
        echo "  overfull boxes in $log:" >&2
        grep -A1 'Overfull \\hbox' "$log" | head -20 | sed 's/^/    /' >&2
        return 1
    fi
}

inject_thesis_nomenclature() {
    python3 - "$1" <<'PY'
import sys

path = sys.argv[1]
text = open(path, encoding="utf-8").read()
marker = r"% \lambang  % Uncomment when you have nomenclature entries defined"
if marker not in text:
    raise SystemExit("thesis \\lambang marker not found")
text = text.replace(
    marker,
    "\\nomenclature{API}{Application Programming Interface}\n"
    + "".join(
        f"\\nomenclature{{ABBR{index:02d}}}{{Abbreviation number {index:02d}}}\n"
        for index in range(1, 61)
    )
    + "\\lambang",
)
open(path, "w", encoding="utf-8").write(text)
PY
}

inject_proposal_nomenclature() {
    python3 - "$1" <<'PY'
import sys

path = sys.argv[1]
text = open(path, encoding="utf-8").read()
marker = "\\tableofcontents"
if marker not in text:
    raise SystemExit("proposal table of contents marker not found")
text = text.replace(
    marker,
    marker
    + "\n\\nomenclature{API}{Application Programming Interface}\n"
    + "".join(
        f"\\nomenclature{{ABBR{index:02d}}}{{Abbreviation number {index:02d}}}\n"
        for index in range(1, 61)
    )
    + "\\lambang",
    1,
)
open(path, "w", encoding="utf-8").write(text)
PY
}

inject_long_metadata() {
    python3 - "$1" <<'PY'
import sys

path = sys.argv[1]
text = open(path, encoding="utf-8").read()
replacements = {
    r"\titleind{JUDUL BAHASA INDONESIA}": (
        r"\titleind{Pengembangan Sistem Informasi Manajemen Pengetahuan "
        r"Berbasis Pembelajaran Mesin untuk Optimalisasi Proses Rekayasa "
        r"Perangkat Lunak Terdistribusi pada Organisasi Besar}"
    ),
    r"\titleeng{JUDUL BAHASA INGGRIS}": (
        r"\titleeng{Development of a Machine Learning-Based Knowledge "
        r"Management Information System for Optimizing Distributed Software "
        r"Engineering Processes in Large Organizations}"
    ),
    r"\fullname{NAMA LENGKAP}": (
        r"\fullname{NAMA MAHASISWA YANG SANGAT PANJANG SEKALI}"
    ),
    r"\firstsupervisor{NAMA DOSEN PEMBIMBING}": (
        r"\firstsupervisor{Prof. Dr. Ir. Nama Dosen Pembimbing Dengan Gelar "
        r"Akademik Panjang, S.T., M.T., Ph.D.}"
    ),
    r"% \secondsupervisor{NAMA DOSEN PEMBIMBING II}": (
        r"\secondsupervisor{Dr. Nama Dosen Pembimbing Kedua Dengan Gelar "
        r"Panjang, S.Kom., M.Cs.}"
    ),
    r"\firstexaminer{NAMA DOSEN PENGUJI 1}": (
        r"\firstexaminer{Dr. techn. Nama Dosen Penguji Pertama Dengan Gelar "
        r"Panjang, S.Kom., M.Cs.}"
    ),
    r"\secondexaminer{NAMA DOSEN PENGUJI 2}": (
        r"\secondexaminer{Nama Dosen Penguji Kedua Dengan Gelar Akademik "
        r"Sangat Panjang, S.Kom., M.Kom., Ph.D.}"
    ),
}
for old, new in replacements.items():
    if old not in text:
        raise SystemExit(f"metadata marker not found: {old}")
    text = text.replace(old, new)
open(path, "w", encoding="utf-8").write(text)
PY
}

test_class_copies() {
    (cd "$ROOT" && make check)
}

test_default_builds() {
    local repo
    repo=$(mktemp -d "$WORK/default.XXXXXX") || return 1
    copy_repo "$repo" || return 1
    build "$repo" proposal "$repo/proposal.log" || return 1
    check_log "$repo/proposal.log" || return 1
    build "$repo" skripsi "$repo/skripsi.log" || return 1
    check_log "$repo/skripsi.log" || return 1
    python3 "$ROOT/tests/check_pdf.py" toc-lists "$repo/template/skripsi/main.pdf" || return 1
    python3 "$ROOT/tests/check_pdf.py" logo "$repo/template/skripsi/main.pdf" || return 1
}

test_thesis_nomenclature() {
    local repo
    repo=$(mktemp -d "$WORK/nomenclature.XXXXXX") || return 1
    copy_repo "$repo" || return 1
    inject_thesis_nomenclature "$repo/template/skripsi/main.tex" || return 1
    build "$repo" skripsi "$repo/skripsi.log" || return 1
    check_log "$repo/skripsi.log" || return 1
    python3 "$ROOT/tests/check_pdf.py" nomenclature "$repo/template/skripsi/main.pdf"
}

test_proposal_nomenclature() {
    local repo
    repo=$(mktemp -d "$WORK/proposal-nomenclature.XXXXXX") || return 1
    copy_repo "$repo" || return 1
    inject_proposal_nomenclature "$repo/template/proposal/main.tex" || return 1
    build "$repo" proposal "$repo/proposal.log" || return 1
    check_log "$repo/proposal.log" || return 1
    python3 "$ROOT/tests/check_pdf.py" nomenclature "$repo/template/proposal/main.pdf"
}

test_long_metadata_and_two_supervisors() {
    local repo
    repo=$(mktemp -d "$WORK/long.XXXXXX") || return 1
    copy_repo "$repo" || return 1
    inject_long_metadata "$repo/template/skripsi/main.tex" || return 1
    build "$repo" skripsi "$repo/skripsi.log" || return 1
    check_log "$repo/skripsi.log"
}

test_english_option() {
    local repo
    repo=$(mktemp -d "$WORK/english.XXXXXX") || return 1
    copy_repo "$repo" || return 1
    python3 - "$repo/template/skripsi/main.tex" <<'PY'
import sys

path = sys.argv[1]
text = open(path, encoding="utf-8").read()
old = r"\documentclass[skripsi,indonesia]{ugmskripsi}"
if old not in text:
    raise SystemExit("documentclass marker not found")
text = text.replace(old, r"\documentclass[skripsi,inggris]{ugmskripsi}", 1)
open(path, "w", encoding="utf-8").write(text)
PY
    build "$repo" skripsi "$repo/skripsi.log" || return 1
    check_log "$repo/skripsi.log" || return 1
    pdftotext -layout "$repo/template/skripsi/main.pdf" - | tr -d '\f' \
        | sed 's/^[[:space:]]*//' | grep -x 'CONTENTS' >/dev/null \
        || { head -1 "$repo/template/skripsi/main.tex" >&2; \
             pdftotext -layout "$repo/template/skripsi/main.pdf" - \
                 | grep -n 'CONTENTS\|DAFTAR ISI' | head >&2; \
             fail "English option did not produce CONTENTS"; }
}

run_test "class file copies match" test_class_copies
run_test "default proposal and thesis builds" test_default_builds
run_test "thesis with nonempty nomenclature" test_thesis_nomenclature
run_test "proposal with nonempty nomenclature" test_proposal_nomenclature
run_test "long titles, long names, and two supervisors" test_long_metadata_and_two_supervisors
run_test "English language option" test_english_option

if (( failures > 0 )); then
    echo "$failures test(s) failed" >&2
    exit 1
fi
echo "all tests passed"
