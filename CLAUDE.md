# Texign — notes for Claude Code

Personal LaTeX ecosystem for István (Romanian/English, humanities, teaching).
Read DECISIONS.md before changing anything visual: every agreed value
(fonts, colours, layout, components) is recorded there and must stay
consistent across all document types.

## Architecture
- LuaLaTeX only. KOMA-Script base for article/book; beamer adapter planned for slides.
- `texign-options.sty`: shared keys (lang, notes). Loaded by classes before \LoadClass.
- `texign-core.sty`: colours, fonts (IBM Plex by file name), babel ini locales, strings.
- `texign-layout.sty`: geometry per note mode, H4 headings, page styles, title block.
- `texign-notes.sty`: \note, \image, imagegrid, margin stack (two runs; zref-savepos).
- `texign-blocks.sty`: K1 boxes, source, quotation, captions, T1/T2 tables.
- `texign-biblio.sty`: biblatex profiles (academia default, chicago, chicago-authordate, authordate, numeric); academia details in `texign-biblio-academia.def`; note citations go through \note.
- `texign-glossary.sty`: glossaries-extra + bib2gls (record mode); custom Romanian sort rule (Java's "ro" puts ș among s); terms and abbreviations from one .bib.
- `texign-structures.sty`: timeline (TikZ remember picture: needs two passes) and comparison (T2 tabular).
- `texign-index.sty` + `texign.ist`: imakeidx, sorted by upmendex (ICU, Romanian); the build runs upmendex with openout_any=a because .texign/ is a dot directory.
- `texign-book.cls`: scrbook, two-sided by default; title page, part pages, appendix label, back matter at chapter level; notes restart per chapter (\g__texign_note_int printed, \g__texign_note_id_int for keys).
- `\texignwide{...}`: text + margin width, extends to the outer side on even pages (\Ifthispageodd, two passes).
- `texign-exercises.sty` + `texign-worksheet.cls`: worksheets. `texign-french.lua`: French punctuation spacing.
- `tools/texign-build`: the build sequence (lualatex → biber → bib2gls → lualatex until stable); `tools/texign` wraps it.
- `scripts/texign-ctl`: user-level install/update/revert/status/remove (releases in ~/.local/share/texign, links in TEXMFHOME and ~/.local/bin); `scripts/texign-update` is the short form. Test: `tests/install.sh`.
- Releases: `VERSION` + CHANGELOG + the version of both classes, checked by `tools/release-check`; process in CONTRIBUTING.md. CI in `.github/workflows/`.
- Internal code is expl3 with prefix `texign`; author commands are short and unprefixed.

## Rules
- Author interface stays small; new options need a reason recorded in DECISIONS.md.
- New user-visible strings go into both string tables in texign-core.sty.
- Run `tests/smoke.sh` after every change; it must print only `ok` lines.
  After changing `scripts/` or `tools/texign`, also run `tests/install.sh`.
- User-facing changes get a line under `## [Unreleased]` in CHANGELOG.md.
- Local commits in this repo are fine. No remotes, pushes, GitHub actions,
  publishing, destructive git operations or installs without István's approval.
- Fonts must come from TeX Live; never depend on system fonts.
- Never add Co-Authored-By or Claude-Session trailers to commits.

## Known constraints
- The kernel `ypos` property records 0 under LuaLaTeX (TL 2026): use zref-savepos.
- Libertinus Mono lacks ș/ț; Plex has no small caps (use \acronym).
- Booktabs rule macros must stay plain expandable macros (\noalign).
- Margin items and endnotes are typeset into boxes when called (citations, counters) and only placed at shipout.
- Tests: `tests/academia` (citation norms) and `tests/glossary` (Romanian order) compare text output with expected files.
