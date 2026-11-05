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
| Citation convention | class option `citations=notes` (default), `authordate`, `numeric` |
| Citing | `\cite[page]{key}`, `\textcite{key}`; `\addbibresource{file.bib}` |
| Bibliography | `\printsources` (primary sources and secondary literature; mark primary entries with `keywords = {primary}`) |

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
