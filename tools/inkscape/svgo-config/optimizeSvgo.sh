#!/bin/sh
# optimize svg files with svgo, using a custom config file to keep useful info (like author/license)
# and don't apply destructive optimizations that would make the image harder to edit

for f in $(find . -type f -name \*.svg)
do
    svgo --config svgo.configGC.js -i "$f"
done
