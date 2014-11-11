#!/bin/sh

$XGETTEXT --from-code utf-8 `find src -name '*.qml' \
           -o -name '*.js'` -cTRANSLATORS -kqsTr -L Java -o $podir/gcompris_qt.pot


