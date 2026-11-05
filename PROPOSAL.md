# Texign — audit and architecture proposal

Status: **draft for review** (2026-11-05). Nothing here is final until it
is moved into `DECISIONS.md`.

## 1. Audit: what exists today

| Item | State | Verdict |
|---|---|---|
| `md2pdf/` (git remote `istorie-petru/mdpdf`) | Markdown → PDF via pandoc + 30 Lua filters + two LaTeX templates + a 1 100-line Bash CLI and a Python project tool. Partly reconstructed after the 2026-08-25 data loss. Files were moved from the repo root into `md2pdf/` but the move is **uncommitted**. | Keep as a separate, frozen tool. Its *ideas* are valuable (semantic colours, callouts, cover/colophon, project folders, `doctor`, `lint`); its *architecture* (design logic spread across pandoc templates and Lua filters, two themes that do not share code) is what Texign should not repeat. |
| `texign/` | Empty folder. | Becomes the new framework. |
| `../latex-styles-documents/texmf/` | `nerdnote.sty` (47 lines, icon note box), `smartfiletree.sty` (empty file). | Fold the useful idea (icon notes, file trees) into Texign components later; do not depend on them. |
| Claude Code setup | No `CLAUDE.md`, agents, skills or project memory found anywhere in the workspace. | Build a small, purposeful one (see §8). |
| Toolchain | TeX Live 2026 (Arch), LuaHBTeX 1.24, biber 2.22, latexmk, l3build, xindy, upmendex, bib2gls, pandoc. `texlive-fontsextra` installed, so all candidate fonts ship *inside TeX Live*. | Good. One gap: the Romanian `babel` `.ldf` is not installed, but babel's built-in `ini` locale works (`\babelprovide[import]{romanian}`) and is the modern route anyway. |

Findings that affect design:

- **Libertinus Mono has no ș/ț** (comma-below). Visible as missing glyphs in specimen B. Any option using it needs a different monospace.
- **IBM Plex Serif has no true small caps**, so specimen D shows lowercase where A–C show small caps.
- **cleveref has no Romanian** names; Texign will define its own reference names (ro/en) rather than add another dependency.
- All candidate fonts encode ș/ț as distinct comma-below glyphs (checked with fontTools), so correct Romanian diacritics are safe in every option.

## 2. Core architecture (recommended)

**One design system, four thin classes.**

```
texign-article.cls   texign-book.cls   texign-worksheet.cls   texign-slides.cls
        \_______________ | _______________ | _______________/
                         texign.sty  (identity: fonts, colours, spacing,
                                      headings, page furniture, components,
                                      academic apparatus, languages)
```

Each class only decides *structure and medium* (page geometry, sectioning
depth, chapter handling, slide frames). Everything visual is loaded from
the shared layer, so a `definition` box or a table looks the same in an
article, a manual, a worksheet and a slide.

Key technical choices:

1. **LuaLaTeX only.** Needed for OpenType fonts, full Unicode, proper
   Romanian hyphenation/diacritics, microtype with OpenType, and Lua for
   data-driven components. pdfLaTeX cannot do the typography; XeLaTeX is
   less maintained and weaker with microtype. *Constraint:* documents will
   not compile on arXiv-style pdfLaTeX-only services.
2. **Base classes: KOMA-Script** (`scrartcl`, `scrbook`) rather than
   `memoir` or the standard classes. KOMA gives article and book *one*
   API for fonts, headings, page styles (`scrlayer-scrpage`), ToC
   (`tocbasic`) and front/back matter, is actively maintained and
   cooperates well with biblatex and babel. `memoir` would also work (it
   even has an article mode) but is monolithic, conflicts with many
   packages, and evolves slowly. *This is a long-term choice; see §9.*
3. **Slides: beamer** with a Texign theme that reads the same colour and
   font tokens. It is the only mature option; the theme is a thin adapter.
4. **Implementation language: expl3** for the internal layer (key–value
   setup with `l3keys`, clean namespacing under `texign`), with ordinary
   LaTeX2e-style author commands on top.
5. **Components on tcolorbox**, loaded with only the libraries actually
   needed (`skins`, `breakable`, `hooks`), behind one internal constructor
   so all boxes share spacing, borders, numbering and colour semantics.
   TikZ/PGF only where drawing is genuinely needed (timelines, diagrams).
6. **Bibliography: biblatex + biber**, exposed as a small number of
   *profiles* (§5) instead of raw biblatex options.
7. **Build: latexmk** driven by a tiny `texign` command (`new`, `build`,
   `watch`, `clean`, `doctor`). Authors never type biber/makeindex runs.
8. **Fonts loaded by file name from TeX Live**, not by system name, so a
   document compiles identically on any Linux machine with TeX Live.

## 3. Author interface (target)

```latex
\documentclass[lang=ro]{texign-article}
\texignsetup{
  citations = author-date,      % or notes, numeric
  sources   = split,            % primary / secondary bibliographies
}
\addbibresource{surse.bib}

\title{Despre lectura atentă}
\subtitle{Note de seminar}
\author{István}

\begin{document}
\maketitle
\begin{definition}[Sursă primară] ... \end{definition}
\begin{source}[Constituția din 1866, art. 1] ... \end{source}
\printsources
\end{document}
```

Principles: few options, sensible defaults, the same option names in
every class, no package imports in documents, plain editable LaTeX.

## 4. Components (first cut, to refine with you)

- **Text blocks** (one family, colour-coded by meaning): `definition`,
  `concept`, `example`, `note`, `warning`, `summary`, `instructions`.
- **Sources and quotations**: `quotation` (with attribution), `source`
  (primary-source extract with provenance line).
- **Layout**: `sidebyside` / `comparison`, `figuregrid` (sub-figures with
  one caption system).
- **Structured information**: `timeline`, `terms` (glossary/terminology
  list), styled `table` defaults (booktabs-based, no vertical rules).
- **Learning**: `exercise`, `question`, `answer`, `answerspace` (lines,
  grid, box), with a class option to hide/show/collect answers. Built in
  Texign rather than on `xsim` (unmaintained since 2022) or `exsheets`
  (deprecated).
- **Margin material**: `\sidenote`, margin figures (book/article).

## 5. Academic apparatus

- Citation profiles: `author-date` (biblatex `ext-authoryear`), `notes`
  (`ext-verbose` / `verbose-trad2` family, footnote citations with ibid.
  handling), `numeric`; optionally `chicago` via biblatex-chicago later.
- Split bibliographies by keyword/category: `\printsources` prints
  primary sources and secondary literature as separate sections.
- Romanian bibliography localisation (`romanian.lbx` is present) and
  Romanian sorting via biber's locale collation.
- Footnotes, sidenotes, optional endnotes (`enotez`), index via
  `imakeidx` + xindy (Romanian sorting), lists of figures/tables,
  appendices, front/back matter, chapter and page styles from KOMA.
- Cross-references with Romanian/English names defined by Texign.

## 6. Repository, versioning, installation

- **Repo layout:** a standard TDS-like source tree (`tex/`, `templates/`,
  `examples/`, `tests/`, `docs/`, `tools/`, `design/`).
- **Install:** user-level only, into `~/texmf` (TEXMFHOME), via
  `l3build install` or a symlink for development. No root/system install.
- **Versioning:** SemVer + git tags, `CHANGELOG.md`, version/date in every
  `\ProvidesExplPackage`.
- **Tests:** `l3build` regression tests for the core, compile-smoke tests
  for every example and template, and optional visual diffs (pdftoppm).
- **Wiki:** GitHub wikis are separate repos (`<repo>.wiki.git`). Clone it
  as a *sibling* folder, not inside the main repo:

  ```
  Development/latex/          ← plain workspace folder
  ├── texign/                 ← main repo
  ├── texign.wiki/            ← wiki repo (independent history)
  └── md2pdf/                 ← legacy tool repo
  ```

  A small `tools/wiki` script in the main repo can check that the wiki is
  cloned next to it and lint its links. Note GitHub only creates the wiki
  repo after the first page is saved in the web UI.

## 7. Development order (risk-first)

1. Identity decisions: typography → colour → headings/page furniture.
2. `texign.sty` core + `texign-article` with real Romanian content.
3. Academic apparatus (biblatex profiles, notes, indexes) — highest
   technical risk, so early.
4. Component system (boxes, sources, tables, figures).
5. `texign-book`, then `texign-worksheet` (exercise system).
6. `texign-slides` (beamer adapter).
7. Templates, `texign` CLI, installer, tests, wiki.

## 8. Claude Code environment

- `texign/CLAUDE.md`: architecture, naming conventions, test commands,
  "never break the public interface without a CHANGELOG entry".
- Two or three skills, only where they repeat: *add a component*,
  *release*, *update the wiki*. No large agent roster.
- `tools/` scripts for build, test and specimen rendering.

## 9. Decisions I need from you

1. **Typography** (now): pick from the specimens in `design/typography/`.
2. **Where Texign lives** (soon, needs your approval because it touches
   git): my recommendation is a *new* GitHub repo `texign`, with this
   folder turned into the plain workspace above, and the existing `mdpdf`
   history kept with `md2pdf/`. That requires moving `.git` from
   `latex/` into `latex/md2pdf/` and committing your pending move there.
3. **KOMA-Script vs memoir** as the base for article/book. I recommend
   KOMA-Script; tell me if you have a specific reason to prefer memoir.
4. **Primary language**: I assume Romanian as default with English as
   the second language. Any others (French, German, Latin, Greek)?
