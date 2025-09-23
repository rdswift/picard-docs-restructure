#! /usr/bin/bash
sphinx-build -M latex . _build
cd _build/latex
ls -l
echo "Building PDF from LaTeX (Pass 1)"
lualatex musicbrainzpicard
echo "Building PDF index"
makeindex -s python.ist musicbrainzpicard
echo "Building PDF from LaTeX (Pass 2)"
lualatex musicbrainzpicard
