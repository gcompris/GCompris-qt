#!/bin/sh
# Convert all svg files in a directory to plain svgz
# needed to compress the output of export_layers_compris inkscape extension,
# as trying to export directly svgz from it seems to break the --export-area-drawing option
#
# Requires inkscape version 1.0 or later

for f in $(find . -type f -name \*.svg)
do
    inkscape --export-plain-svg --export-filename=${f%.*}.svgz $f
done
