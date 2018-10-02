#!/bin/bash
#
# move_translations.sh
# 
# Copyright (C) 2018 Johnny Jazeix
# 
# This is a (temporary) script to move translations retrieved by releaseme
# fetchpo.rb script. The final aim is to have the po in the good arborescence
# for all the platforms, like they are retrieved from svn:
# poFolder/$locale/gcompris_qt.po
# (where for now, it is: sourceFolder/po/gcompris_$locale.po)
#
# $1 is where the folder containing the po retrieved by the script
# $2 is the destination folder
if [ "$#" -ne 2 ]; then
    echo "usage: $0 poFolder destinationFolder"
    exit 1
fi

if [ ! -d "$2" ]; then
    mkdir -p $2
fi

for filename in $1/*/*.po; do
    locale=$(basename $(dirname $filename))
    mv $filename $2/gcompris_$locale.po
done
