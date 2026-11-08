# Changelog

All notable changes to Texign are recorded here, one entry per tagged
release. The format loosely follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

- Timeline dots and connecting lines both use the accent colour.
- Much more space above and below headings.
- Long words and URLs: looser line breaking, URLs in notes and bibliography
  break anywhere, table cells can hyphenate their first word.
- Comparison tables keep their caption on the same page.
- `texign doctor` reports missing Romanian hyphenation patterns.

## [0.1.0]

The first release: two document classes with one visual identity.

- Classes: `texign-article` and `texign-book` (KOMA-Script, LuaLaTeX), in
  Romanian (default) or English. IBM Plex type, Bordo accent, numbered
  headings with a "CAPITOLUL 1" label in a wide margin column.
- Notes: one `\note{}` command set as footnotes (default), margin notes or
  endnotes by a class option. Notes inside information boxes reach the foot
  of the page.
- Images: `\image` with automatic placement, `[body]` and `[wide]`
  variants, capped heights, captions always below, and `imagegrid`.
- Components: information boxes, sources, quotations with their source in
  the margin, booktabs tables in two styles, timelines and comparison
  tables.
- Citations: `citations=academia` (Romanian Academy norms, the default),
  `chicago`, `chicago-authordate`, `authordate`, `numeric`;
  `\printsources` splits primary sources from secondary literature.
- Glossary and abbreviations through bib2gls with Romanian order; contents,
  figure and table lists; a Romanian index through upmendex.
- Books: title page, parts, appendices, notes restarting per chapter, full
  citation again at the start of every chapter.
- Layout: half-line paragraph spacing, airier floats, emergency stretch for
  justified Romanian text, headings never stranded at the foot of a page.
- `texign` command: `build` (the visible build sequence), `watch`, `new`,
  `clean`, `doctor`.
- Installation: `texign-ctl` installs, updates, reverts and removes Texign
  for one user, without root; a new release must build a test document
  before it becomes current.
