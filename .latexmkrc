# Texign build settings: LuaLaTeX + biber, quiet, output next to the source.
$pdf_mode = 4;            # lualatex
$lualatex = 'lualatex -interaction=nonstopmode -file-line-error -halt-on-error %O %S';
$bibtex_use = 2;          # run biber when needed, clean its files
$max_repeat = 5;
ensure_path('TEXINPUTS', './tex/latex/texign//');
