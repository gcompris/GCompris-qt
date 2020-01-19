#!/bin/sh

# Extract strings from all source files.
# EXTRACT_TR_STRINGS extracts strings with lupdate and convert them to .pot with
# lconvert.
$EXTRACT_TR_STRINGS `find . -name \*.cpp -o -name \*.h -o -name \*.qml -o -name \*.js` -o $podir/gcompris_qt.pot

# create a pot for the voices text to keep them up-to-date with the audio files
find . -name ActivityInfo.qml -exec awk -f activityintro2msg.awk {} \; > rc.cpp
$XGETTEXT rc.cpp -o $podir/gcompris_voices.pot
rm rc.cpp

