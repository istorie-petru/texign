% texign-worksheet.cls — worksheets, tests and learning activities.
%   \documentclass[lang=ro|en|fr, answers=hide|show|end]{texign-worksheet}
% Same identity as texign-article; \maketitle adds name, class, date and
% score fields (the total is added up from the exercises).
\NeedsTeXFormat{LaTeX2e}[2023-11-01]
\ProvidesExplClass{texign-worksheet}{2026/11/08}{0.1.0}{Texign worksheet}
\RequirePackage{texign-options}
\ProcessKeyOptions[texign]
\LoadClass[paper=a4,fontsize=10.5pt,twoside=false,parskip=false,headings=standardclasses]{scrartcl}
\RequirePackage{texign-core}
\RequirePackage{texign-layout}
\RequirePackage{texign-notes}
\RequirePackage{texign-blocks}
\RequirePackage{texign-biblio}
\RequirePackage{texign-structures}
\RequirePackage{texign-index}
\RequirePackage{hyperref}
\hypersetup{ hidelinks , colorlinks = true , allcolors = accent , linktoc = page , pdfcreator = Texign }
\RequirePackage{texign-glossary}
\RequirePackage{texign-exercises}

\cs_new_protected:Npn \__texign_field:nnn #1#2#3
  % #1 string key, #2 width as a fraction of the line, #3 text after the rule
  {
    \makebox [ #2 \linewidth ] [ l ]
      {
        \sffamily \small \color{muted} \texign_string:n {#1} \enspace
        \textcolor{rule} { \hrulefill } #3 \hspace { 1em }
      }
  }
\RenewDocumentCommand \maketitle { }
  {
    \__texign_titleblock:
    \noindent
    \__texign_field:nnn { name } { 0.44 } { }
    \__texign_field:nnn { class } { 0.16 } { }
    \__texign_field:nnn { date } { 0.18 } { }
    \__texign_field:nnn { score } { 0.22 }
      { \tl_if_empty:NF \texignworksheettotal { \enspace / \enspace \exp_args:Ne \__texign_number:n { \texignworksheettotal } } }
    \par \vspace { 10pt }
    \thispagestyle { plain.scrheadings }
  }
