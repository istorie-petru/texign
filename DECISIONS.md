# Texign — design and architecture decisions

Agreed decisions only. Proposals under discussion live in `PROPOSAL.md`.
Each entry: date, decision, reason.

## Open


## Agreed

### 2026-11-05 · Typeface: IBM Plex superfamily (option D)

Chosen by István: very readable, light on the page, well spaced.

- Body (article, book, worksheet): **IBM Plex Serif** Regular; bold = SemiBold.
- Headings, captions, labels, tables headers, UI text: **IBM Plex Sans**
  (SemiBold for headings). Slides use Plex Sans as body text.
- Dense tables/sidebars may use **IBM Plex Sans Condensed**.
- Code: **IBM Plex Mono**. Maths: **IBM Plex Math** (ships with TeX Live,
  via `unicode-math`) — this removes Plex's main weakness.
- Fonts loaded by file name from TeX Live (`fonts/opentype/ibm/plex`).
- No true small caps in Plex: Texign will not rely on `\textsc`.
  Acronyms are set in full caps with light tracking via a dedicated
  macro; bibliography styles must not use small caps for names.
- Plex Serif "Text" weight (between Regular and Medium) is reserved as a
  possible option for projection/low-resolution output; not default.

### 2026-11-05 · Colour: palette B "Bordo", slightly lighter than first draft

Chosen by István ("B Bordo, dar cu o tentă un pic mai luminată").
Semantics: accent = headings, links, definitions; green = examples;
grey = notes; ochre = warnings; sepia = primary sources; ink #1F2328 text.
Boxes: thin left bar + 6 % tint, no frames. Final values (variant B2, chosen 2026-11-05):

| Token | Hex | Use |
|---|---|---|
| ink | #1F2328 | body text |
| muted | #6A737D | secondary text, labels |
| rule | #D0D4D9 | hairlines, answer lines |
| accent | #963A45 | headings numbers, links, definitions (7.0:1 on white) |
| example | #4F7149 | examples |
| note | #647080 | notes |
| warning | #B0781F | warnings |
| source | #74624F | primary sources |

### 2026-11-05 · Page layout and headings: H4 (margin column + H2 numbering)

István likes the H4 design (`design/headings/spread-H4.png`).

- Wide outer margin column (text 118 mm, margin 42 mm, gap 8 mm on A4).
- Chapter: letterspaced "CAPITOLUL n" label in accent, title in Plex Sans
  SemiBold, accent rule across text + margin.
- Section numbers inline before the title (accent for sections, muted for
  subsections).
- Header across text + margin: chapter title left, page number right in accent.
- **No first-line indent after any heading** (also after chapter abstracts).

### 2026-11-05 · Notes: one author command, `\note{...}`, three modes

- **Default mode: `foot`** (István, 2026-11-05). `margin` and `end` are
  opt-in through the class option `notes=`.

- `margin`: notes are always numbered and stacked from the top of
  the margin column of the page they belong to (consistent spacing, no
  alignment with the reference line). On a chapter-opening page the stack
  starts below the title block. Margin figures join the same stack.
- `foot` and `end` are the same source rendered as footnotes or endnotes.
- Prototype: `design/notes/proto-notes.sty` (needs two runs; latexmk does it).
- The note mode also decides the page layout: only `margin` reserves the
  margin column. `foot`/`end` use a wider single text block (30 mm side
  margins on A4); header, chapter rule and wide figures follow that width.
- **Universal image rule** (István, 2026-11-05): `\image[where]{file}{caption}`.
  - `auto` (default): in `margin` mode *every* image goes to the margin
    stack; the body is reserved for text, tables, diagrams and images that
    explicitly need space. In `foot`/`end` modes the image is set in the
    text: a lone image at half width with its caption beside it;
    consecutive images (blank lines allowed between them) form one row,
    max. 3 across.
  - `body`: always in the text column. `wide`: across text + margin (or
    the full text width without a margin column).
  - Image grids (several sub-images, one caption) stay in the body.
  - Figure numbers are identical in every mode; a missing file renders as
    a labelled placeholder.
- Confirmed by István 2026-11-05.

### 2026-11-05 · Information boxes K1, tables T1 (T2 on demand)

Chosen by István. Mockups: `design/blocks/blocks-and-tables.pdf`.

- Boxes (definition, concept, example, note, warning, summary,
  instructions, primary source): 2.2 pt bar in the semantic colour on the
  left, 6 % tint background, no frame, sans label at the start of the text
  ("Definiție · Sursă primară."). Primary-source extracts in italic.
- Tables: T1 by default (booktabs, no vertical rules, 0.8 pt accent top
  rule, hairlines in `rule` grey, sans header, tabular figures). T2
  (accent-tinted header, faint alternating rows) available on request, and
  the default for the comparison component. Dense tables use Plex Sans
  Condensed.
- **Quotations:** the attribution ("— Nicolae Iorga, *Istoria…*, 1928")
  sits in the margin column level with the quotation, as plain note text
  (K3 style). Without a margin column it falls back to right-aligned
  below the quotation. Implementation must keep it from colliding with
  the stacked margin notes (anchored items reserve their position; the
  stack flows around them).

### 2026-11-05 · Repository, base classes, languages (István)

- `texign/` is the Git repository of the framework (future GitHub repo).
  `md2pdf/` stays the Markdown tool with its own repository (remote
  `istorie-petru/mdpdf`; its `.git` moved from `latex/` into `md2pdf/`).
  The wiki is a separate clone in its own folder at the root of `latex/`.
- Base classes: KOMA-Script.
- Languages: Romanian (default) and English only.

### 2026-11-05 · Citations and bibliography

István: notes and bibliography follow the rules of the Romanian Academy
(a variant) or Chicago.

- biblatex + biber; one class option `citations`:
  - `academia` (default): follows "Sistem de citare și referințe, conform
    normelor Academiei Române" (Editura Universității din Oradea, 2024),
    supplied by István. Notes: full "Given Family", *italic title*, vol.,
    place, publisher, year, p.; studies in periodicals and collective
    volumes also italic ("…, în *Revista istorică*, VIII, 1995, nr. 9-10,
    p. 671-677"); newspapers (`entrysubtype = {newspaper}`) "…, XC, nr. 33
    din 1 aprilie 1925"; online "url, date of access"; no year: "f. a.";
    repeats *Ibidem*, *Idem*, "Family, *op. cit.*, p." or "Family, short
    title, p." for authors with several works; "Cf." and "passim" via
    `\cite[Cf.][35]{key}` and `\cite[passim]{key}`. Ranges with a hyphen,
    as in the norms. Bibliography alphabetical, "Family, Given, …".
    Regression test: `tests/academia/` reproduces the examples of the norms.
    Deliberate deviations: dates in full ("3 noiembrie 2004" rather than
    "3 nov. 2004") so all dates look alike; within a document a cited
    article shows the cited page instead of its full page range.
  - `chicago` / `chicago-authordate`: biblatex-chicago (CMOS 18).
  - `authordate`, `numeric`: generic biblatex-ext / biblatex styles.
- `\cite` is written before punctuation; with notes the mark moves after it,
  inline styles get a leading space.
- Note citations go through `\note` and follow the note mode.
- `\printsources`: "Bibliografie", then "Surse primare" (`keywords =
  {primary}`) and "Literatură secundară". Romanian sorting (`ro_RO`), no
  small caps; `legislation`, `legal`, `archive` accepted (as misc).
- Margin overflow: items that do not fit move, in order, to the next page.

### 2026-11-05 · Build sequence

István asked for a clear build sequence. `texign build` runs: LuaLaTeX →
Biber (only if needed) → LuaLaTeX until the auxiliary files are stable
(max. 5 passes), prints each step, and stops at the first error with file
and line. Auxiliary files in `.texign/`, PDF next to the source.

### 2026-11-06 · Glossary, lists, chronology, comparison (István asked for these)

- **Glossary** ("care se face corect"): glossaries-extra in record mode with
  bib2gls, so only used terms appear, with page references, sorted by
  **Romanian alphabetical rules** (a < ă < â, i < î, s < ș, t < ț; comma and
  cedilla forms both handled; Java's built-in Romanian collation gets ș
  wrong, so Texign supplies its own rule). Terms and abbreviations live in
  one .bib file. In the text terms look like ordinary text (no link
  colour); in the list the term is sans semibold, then the description,
  then page numbers. Abbreviations: first use "long (SHORT)", short forms
  in lightly tracked capitals; list "Abrevieri" with a short-form column.
  Plurals must be given (`plural = {...}`): Romanian plurals are not "+s".
- **Contents, list of figures, list of tables**: one style — accent sans
  numbers, titles in ink (only page numbers are links), page numbers flush
  right, no leader dots; section entries in sans semibold. Images placed in
  the margin are listed too. Titles: Cuprins, Lista figurilor, Lista
  tabelelor.
- **Timeline** (`timeline`, `\event`): accent sans dates in a right-aligned
  column, an accent dot per event joined by a grey hairline, title in sans
  semibold, description in the text face. Breaks only between events.
  Optional title shown as "CRONOLOGIE · title".
- **Comparison** (`comparison`, `\compare`): the T2 structured table with a
  criteria column and 2–3 compared columns; optional caption numbers it as
  a table.

## Known constraints

- 2026-11-05 · The LaTeX kernel `ypos` property records 0 under LuaLaTeX
  (TL 2026); margin positions use zref-savepos instead.

- 2026-11-05 · Engine target is LuaLaTeX (proposed; pending confirmation).
- 2026-11-05 · Libertinus Mono lacks ș/ț; never use it for Romanian text.
- 2026-11-05 · IBM Plex Serif has no true small caps.
- 2026-11-05 · Romanian babel `.ldf` not installed locally; use
  `\babelprovide[import]{romanian}` (ini-based locale).
