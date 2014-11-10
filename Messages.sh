#!/bin/sh

$XGETTEXT `find src -name '*.qml' \
           -o -name '*.js'` -cTRANSLATORS -kqsTr -L Java -o $podir/gcompris_qt.pot

echo $XGETTEXT
echo $XGETTEXT_QT

#$XGETTEXT `find src -name '*.qml'` -kqsTr:1c,2,2t -L Java -o $podir/gcompris_qt.pot
#$XGETTEXT src/activities/ballcatch/Ballcatch.qml  -kqsTr -L Java -o $podir/gcompris_qt.pot
