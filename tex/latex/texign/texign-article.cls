% texign-article.cls — articles, papers, essays, reports.
%   \documentclass[lang=ro|en, notes=foot|margin|end, citations=...]{texign-article}
\NeedsTeXFormat{LaTeX2e}[2023-11-01]
\ProvidesExplClass{texign-article}{2026/11/05}{0.1.0}{Texign article}
\RequirePackage{texign-options}
\ProcessKeyOptions[texign]
\LoadClass[paper=a4,fontsize=10.5pt,twoside=false,parskip=false,headings=standardclasses]{scrartcl}
\RequirePackage{texign-core}
\RequirePackage{texign-layout}
\RequirePackage{texign-notes}
\RequirePackage{texign-blocks}
\RequirePackage{texign-biblio}
\RequirePackage{hyperref}
\hypersetup{ hidelinks , colorlinks = true , allcolors = accent , pdfcreator = Texign }
