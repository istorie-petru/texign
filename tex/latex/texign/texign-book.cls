% texign-book.cls — long documents: books, theses, manuals, curricula.
%   \documentclass[lang=ro|en, notes=foot|margin|end, citations=...,
%                  sides=two|one, open=right|any]{texign-book}
% Structure: \frontmatter \maketitle \tableofcontents ... \mainmatter
%            \part \chapter \section ... \appendix \chapter ... \backmatter
% Same identity as texign-article; notes restart with every chapter.
\NeedsTeXFormat{LaTeX2e}[2023-11-01]
\ProvidesExplClass{texign-book}{2026/11/06}{0.1.0}{Texign book}
\RequirePackage{texign-options}
\ProcessKeyOptions[texign]
\use:e
  {
    \exp_not:N \LoadClass
      [ paper = a4 , fontsize = 10.5pt , parskip = false , headings = standardclasses ,
        twoside = \str_if_eq:VnTF \g_texign_sides_tl { two } { true } { false } ,
        open = \g_texign_open_tl , chapterprefix = true ]
      { scrbook }
  }
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

% blank pages before a right-hand chapter are really blank; numbers without
% a final period ("1.1", not "1.1.")
\KOMAoptions { cleardoublepage = empty , numbers = noendperiod }

% contents: chapters in sans semibold, sections in the text face
\DeclareTOCStyleEntry
  [ dynnumwidth , linefill = \hfill , pagenumberformat = \__texign_toc_page:n ,
    entrynumberformat = \__texign_toc_number:n , beforeskip = 1pt plus 1pt ,
    entryformat = \color{ink} , level = 1 , indent = 1.5em ]
  { tocline } { section }
\DeclareTOCStyleEntry
  [ dynnumwidth , linefill = \hfill , pagenumberformat = \__texign_toc_page:n ,
    entrynumberformat = \__texign_toc_number:n , beforeskip = 14pt plus 2pt ,
    entryformat = \sffamily \bfseries \color{accent} , level = -1 , indent = 0pt ]
  { tocline } { part }

% ---- chapters: start lower on the page ---------------------------------------
\renewcommand* \chapterheadstartvskip { \vspace* { 22mm } }
% chapter pages: no running head, only the page number
\ihead [ ] { \headmark }
\ohead [ \pagemark ] { \pagemark }

% ---- parts: own page, "PARTEA I" label, large sans title ---------------------
\renewcommand* \partformat
  {
    \textsf { \small \mdseries \color{accent} \addfontfeatures { LetterSpace = 10 }
      \text_uppercase:n { \texign_string:n { part } } \nobreakspace \thepart }
  }
\renewcommand* \raggedpart { \raggedright }
\renewcommand* \partheadstartvskip { \vspace* { 60mm } }
\renewcommand* \partheadmidvskip { \par \vspace { 8pt } }
\setkomafont { part } { \sffamily \bfseries \fontsize{28}{34} \selectfont \color{ink} }
\setkomafont { partnumber } { }
\renewcommand* \partpagestyle { empty }

% ---- appendices: "ANEXA A" ------------------------------------------------------
\cs_new_protected:Npn \appendixmore
  {
    \renewcommand* \chapterformat
      {
        \textsf { \small \mdseries \color{accent} \addfontfeatures { LetterSpace = 10 }
          \text_uppercase:n { \texign_string:n { appendix } } \nobreakspace \thechapter }
        \par \vspace{4pt}
      }
  }

% ---- title page ---------------------------------------------------------------
% \subject{label} \title \subtitle \author \date \publishers{place, publisher}
% \dedication{text} (own page)
\RenewDocumentCommand \maketitle { }
  {
    \begin{titlepage}
      \thispagestyle { empty }
      \vspace* { 30mm }
      \noindent
      \tl_if_empty:NF \@subject
        {
          { \sffamily \small \color{accent} \addfontfeatures { LetterSpace = 10 }
            \text_uppercase:n { \@subject } } \par \vspace { 6pt }
        }
      \noindent { \sffamily \bfseries \fontsize{30}{36} \selectfont \raggedright \@title \par }
      \tl_if_empty:NF \@subtitle
        { \vspace { 8pt } \noindent { \sffamily \Large \color{muted} \raggedright \@subtitle \par } }
      \vspace { 14pt }
      \noindent { \color{accent} \rule { \textwidth } { 0.8pt } } \par
      \vspace { 14pt }
      \noindent { \sffamily \large \color{ink} \@author \par }
      \vfill
      { \sffamily \small \color{muted} \parindent = 0pt
        \tl_if_empty:NF \@publishers { \@publishers \par }
        \@date \par }
    \end{titlepage}
    \legacy_if:nT { @twoside } { \thispagestyle { empty } \null \clearpage }
    \tl_if_empty:NF \@dedication
      {
        \thispagestyle { empty } \null \vspace* { 50mm }
        \begin{center} \itshape \@dedication \par \end{center}
        \clearpage
        \legacy_if:nT { @twoside } { \thispagestyle { empty } \null \clearpage }
      }
    \cs_gset_eq:NN \@subject \c_empty_tl
  }
