#!/bin/sh
#=============================================================================
# SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
#
# Convert all svg files in a directory to plain svgz
# needed to compress the output of export_layers_compris inkscape extension,
# as trying to export directly svgz from it seems to break the --export-area-drawing option
#
# Requires inkscape version 1.0 or later

for f in $(find . -type f -name \*.svg)
do
    inkscape --export-plain-svg --export-filename=${f%.*}.svgz $f
done
