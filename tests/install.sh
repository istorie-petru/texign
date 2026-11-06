#!/usr/bin/env bash
# The install life cycle of scripts/texign-ctl in a throwaway home folder:
# install a release tag, build with the installed command, update to a newer
# tag, revert, refuse a broken release, remove. Uses the committed HEAD of
# this repository; nothing outside a temporary directory is touched.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
want="$(git -C "$ROOT" show HEAD:VERSION)"   # read before HOME and the git config change
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home" TEXMFHOME="$tmp/home/texmf" XDG_DATA_HOME="$tmp/home/.local/share"
export PATH="$HOME/.local/bin:$PATH" GIT_CONFIG_GLOBAL=/dev/null
unset TEXIGN_HOME TEXIGN_BIN TEXINPUTS
mkdir -p "$HOME"
fail=0
check() { local name="$1"; shift; if "$@" >"$tmp/out" 2>&1; then echo "ok    install-$name"; else echo "FAIL  install-$name"; sed 's/^/      /' "$tmp/out" | tail -10; fail=1; fi; }
git_src() { git -C "$tmp/src" -c user.name=test -c user.email=test@example.invalid "$@"; }

# a source repository with three releases; the last one does not compile
git clone -q "file://$ROOT" "$tmp/src"
git_src remote remove origin   # updates come from this copy, not from $ROOT
git_src tag v0.0.1
echo 0.0.2 >"$tmp/src/VERSION"; git_src commit -qam 'Release v0.0.2'; git_src tag v0.0.2
ctl="$tmp/src/scripts/texign-ctl"

check first-install       "$ctl" install --ref=v0.0.1
check first-version     test "$(texign-ctl version)" = "$want"
check tex-finds-class     test "$(kpsewhich texign-article.cls)" = "$TEXMFHOME/tex/latex/texign/texign-article.cls"
cp -r "$ROOT/tests/install" "$tmp/doc"
check author-command      texign build "$tmp/doc/check.tex"
check pdf-written         test -s "$tmp/doc/check.pdf"
check update              texign-update
check version-0.0.2       test "$(texign-ctl version)" = 0.0.2
check up-to-date          bash -c 'texign-ctl update | grep -q "Already up to date"'
check revert              texign-update --revert
check reverted-version    test "$(texign-ctl version)" = "$want"

echo '\errmessage{broken release}' >>"$tmp/src/tex/latex/texign/texign-article.cls"
echo 0.0.3 >"$tmp/src/VERSION"; git_src commit -qam 'Release v0.0.3'; git_src tag v0.0.3
check broken-refused      bash -c '! texign-ctl update'
check still-reverted    test "$(texign-ctl version)" = "$want"
check status              texign-ctl status

check remove              texign-ctl remove --yes
check nothing-left        bash -c '! ls -A "$HOME/.local/bin" | grep -q . && [ ! -e "$XDG_DATA_HOME/texign" ] && [ ! -L "$TEXMFHOME/tex/latex/texign" ]'

# development mode links to the clone itself
check dev-install         "$ctl" install --dev
check dev-link            test "$(readlink -f "$TEXMFHOME/tex/latex/texign")" = "$tmp/src/tex/latex/texign"
check dev-remove          texign-ctl remove --yes
check source-untouched    test -f "$tmp/src/tex/latex/texign/texign-article.cls"
exit $fail
