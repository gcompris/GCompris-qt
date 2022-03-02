#!/bin/sh
# Convert all svg files in a directory to png
#
# Requires smillaenlarger and imagemagick

for f in $(find . -type f -name \*.jpg)
do
    magick $f -resize 320x320 -quality 90 -define webp:lossless=false -define webp:method=6 ${f%.*}.webp
done

rm -Rf *.jpg
