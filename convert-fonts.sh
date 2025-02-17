#! /bin/bash

# USAGE:
#./convert-fonts.sh /usr/local/texlive/2024/texmf-dist/fonts/type1/urw/times

LATEX_FONT_DIR=$1

for filename in $LATEX_FONT_DIR/*.pfb; do
    NAME=`basename $filename .pfb`
    fontforge -lang=ff -c "Open(\"$filename\"); Generate(\"$NAME.otf\");"
done

