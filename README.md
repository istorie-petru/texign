# Texign

A personal LaTeX ecosystem: document classes, one visual identity, reusable
components, templates and documentation. LuaLaTeX only.

## For writing documents

```bash
tools/texign new article eseu      # start eseu.tex from the template
tools/texign build eseu.tex        # PDF (all runs, biber included)
tools/texign watch eseu.tex        # rebuild on save
tools/texign doctor                # check toolchain and fonts
```

Inside a document you only need:

| Purpose | Command |
|---|---|
| Document type | `\documentclass[notes=margin|foot|end, lang=ro|en]{texign-article}` |
| Notes | `\note{...}` (margin column, footnotes or endnotes, by the class option) |
| Images | `\image{file}{caption}`, `\image[body]{..}{..}`, `\image[wide]{..}{..}` |
| Image grid | `\begin{imagegrid}[cols]{caption} \gridimage{file}{caption} ... \end{imagegrid}` |
| Boxes | `definition`, `concept`, `example`, `remark`, `warning`, `summary`, `instructions` (optional `[title]`) |
| Sources | `\begin{source}{provenance} ... \end{source}` |
| Quotations | `\begin{quotation}[attribution] ... \end{quotation}` |
| Tables | booktabs rules as usual, `\head{..}` for header cells, `\structuredtable` for the T2 style |
| Acronyms | `\acronym{unesco}` |
| Citation convention | class option `citations=academia` (default, Romanian academic notes), `chicago`, `chicago-authordate`, `authordate`, `numeric` |
| Citing | `\cite[page]{key}` written before punctuation, `\textcite{key}`; `\addbibresource{file.bib}` |
| Newspapers | `@article` with `entrysubtype = {newspaper}` |
| Bibliography | `\printsources` (primary sources and secondary literature; mark primary entries with `keywords = {primary}`) |

## The build sequence

`texign build FILE.tex` always runs the same, visible sequence:

```
texign build article.tex
  1. LuaLaTeX — first pass                  ok
  2. Biber — bibliography                   ok (6 entries)
  3. LuaLaTeX — pass 2 (references, margin) ok
  → article.pdf, 2 pages, 8.2 s (3 warnings in .texign/article.log)
```

1. **LuaLaTeX, first pass**: reads the document and writes citations,
   labels and margin positions to the auxiliary files.
2. **Biber**: only if the document has a bibliography.
3. **LuaLaTeX, further passes**: repeated until labels, citations and
   margin positions stop changing (at most four more passes).

Auxiliary files go to `.texign/` next to the document; the PDF goes next
to the document. On an error the build stops and shows the first LaTeX
error with its file and line. `texign clean FILE.tex` removes `.texign/`.
`.latexmkrc` is kept for editors that call latexmk themselves.

## Layout of this repository

```
tex/latex/texign/   the framework (classes and packages)
templates/          starting points for `texign new`
examples/           real documents, also used by the tests
tests/              smoke tests (every example in every note mode)
tools/texign        the author command
design/             design exploration and specimens behind DECISIONS.md
DECISIONS.md        agreed design and architecture decisions
PROPOSAL.md         the original architecture proposal
```

## Workspace and wiki

```
Development/latex/
├── texign/        this repository
├── texign.wiki/   the GitHub wiki, cloned separately (own history)
└── md2pdf/        the Markdown tool (separate repository)
```

The wiki is never a subdirectory or submodule of this repository. It is
created on GitHub after the first wiki page is saved, then cloned next to
this folder.

Status: early development (0.1). Only `texign-article` exists so far.
