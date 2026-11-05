#!/usr/bin/env bash
# Compile every example in every note mode; fail on any LaTeX error or on
# Texign warnings. Output goes to a temporary directory.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export TEXINPUTS="$ROOT/tex/latex/texign//:${TEXINPUTS:-}"
out="$(mktemp -d)"; trap 'rm -rf "$out"' EXIT
fail=0
for src in "$ROOT"/examples/*/*.tex; do
  for mode in margin foot end; do
    name="$(basename "${src%.tex}")-$mode"
    dir="$out/$name"; mkdir -p "$dir"; cp -r "$(dirname "$src")"/. "$dir"/
    sed -E "s/notes=(margin|foot|end)/notes=$mode/" "$src" > "$dir/$name.tex"
    if (cd "$dir" && latexmk -r "$ROOT/.latexmkrc" "$name.tex" >/dev/null 2>&1) \
       && ! grep -q 'Package texign Warning' "$dir/$name.log"; then
      echo "ok    $name"
    else
      echo "FAIL  $name"; grep -E '^\S+:[0-9]+:|texign Warning' -A2 "$dir/$name.log" | head -8 || true; fail=1
    fi
  done
done
exit $fail
