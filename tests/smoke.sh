#!/usr/bin/env bash
# Build every example through the real build sequence (tools/texign-build):
# each note mode, and each citation convention. Fails on any LaTeX error,
# Biber error or Texign warning. Output goes to a temporary directory.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export TEXINPUTS="$ROOT/tex/latex/texign//:${TEXINPUTS:-}"
out="$(mktemp -d)"; trap 'rm -rf "$out"' EXIT
fail=0
variants=(
  "notes=margin"  "notes=foot"  "notes=end"
  "notes=foot,citations=chicago"  "notes=foot,citations=chicago-authordate"
  "notes=foot,citations=authordate"  "notes=foot,citations=numeric"
)
for src in "$ROOT"/examples/*/*.tex; do
  for opts in "${variants[@]}"; do
    name="$(basename "${src%.tex}")-${opts//[=,]/-}"
    dir="$out/$name"; mkdir -p "$dir"; cp -r "$(dirname "$src")"/. "$dir"/
    sed -E "s/\\\\documentclass(\[[^]]*\])?\{/\\\\documentclass[$opts]{/" "$src" > "$dir/$name.tex"
    if "$ROOT/tools/texign-build" "$dir/$name.tex" >"$dir/build.out" 2>&1 \
       && ! grep -q 'Package texign Warning' "$dir/.texign/$name.log"; then
      echo "ok    $name"
    else
      echo "FAIL  $name"; sed 's/^/      /' "$dir/build.out" | tail -8; fail=1
    fi
  done
done
# the Romanian Academy profile against the examples of the norms
dir="$out/academia"; cp -r "$ROOT/tests/academia" "$dir"
if "$ROOT/tools/texign-build" "$dir/norme.tex" >"$dir/build.out" 2>&1 \
   && diff <(pdftotext -raw "$dir/norme.pdf" - | grep -v '^$' | sed -n '/^1 Sabina/,$p') \
           "$ROOT/tests/academia/expected-notes.txt" >"$dir/diff.out"; then
  echo "ok    academia-norms"
else
  echo "FAIL  academia-norms"; sed 's/^/      /' "$dir/diff.out" "$dir/build.out" | tail -12; fail=1
fi
# Romanian alphabetical order in the glossary
dir="$out/glossary"; cp -r "$ROOT/tests/glossary" "$dir"
if "$ROOT/tools/texign-build" "$dir/sortare.tex" >"$dir/build.out" 2>&1 \
   && diff <(pdftotext -raw "$dir/sortare.pdf" - | sed -n '/^Glosar/,$p' | grep -v '^$' | sed '/^[0-9]*$/d') \
           "$ROOT/tests/glossary/expected.txt" >"$dir/diff.out"; then
  echo "ok    glossary-order"
else
  echo "FAIL  glossary-order"; sed 's/^/      /' "$dir/diff.out" "$dir/build.out" | tail -12; fail=1
fi
exit $fail
