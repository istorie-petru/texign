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
- `tools/texign-build`: the build sequence (lualatex → biber → lualatex until stable); `tools/texign` wraps it.
- Internal code is expl3 with prefix `texign`; author commands are short and unprefixed.

## Rules
- Author interface stays small; new options need a reason recorded in DECISIONS.md.
- New user-visible strings go into both string tables in texign-core.sty.
- Run `tests/smoke.sh` after every change; it must print only `ok` lines.
- Local commits in this repo are fine. No remotes, pushes, GitHub actions,
  publishing, destructive git operations or installs without István's approval.
- Fonts must come from TeX Live; never depend on system fonts.

## Known constraints
- The kernel `ypos` property records 0 under LuaLaTeX (TL 2026): use zref-savepos.
- Libertinus Mono lacks ș/ț; Plex has no small caps (use \acronym).
- Booktabs rule macros must stay plain expandable macros (\noalign).
- Margin items and endnotes are typeset into boxes when called (citations, counters) and only placed at shipout.
- Harmless biblatex warning "Language 'nil' not supported" at \begin{document}; not yet traced.
