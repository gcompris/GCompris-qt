/* GCompris
 *
 * SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Horia PELLE <horricane@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Historical provinces of Romania")
   property var levels: [
      {
         "pixmapfile" : "romania/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "romania/oltenia.png",
         //: Historical Province of Romania: Oltenia
         "toolTipText" : qsTr("Oltenia"),
         "x" : "0.346",
         "y" : "0.787"
      },
      {
         "pixmapfile" : "romania/muntenia.png",
         //: Historical Province of Romania: Muntenia
         "toolTipText" : qsTr("Muntenia"),
         "x" : "0.629",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "romania/dobrogea.png",
         //: Historical Province of Romania: Dobrogea
         "toolTipText" : qsTr("Dobrogea"),
         "x" : "0.873",
         "y" : "0.776"
      },
      {
         "pixmapfile" : "romania/moldova.png",
         //: Historical Province of Romania: Moldova
         "toolTipText" : qsTr("Moldova"),
         "x" : "0.693",
         "y" : "0.307"
      },
      {
         "pixmapfile" : "romania/bucovina.png",
         //: Historical Province of Romania: Bucovina
         "toolTipText" : qsTr("Bucovina"),
         "x" : "0.567",
         "y" : "0.155"
      },
      {
         "pixmapfile" : "romania/transilvania.png",
         //: Historical Province of Romania: Transilvania
         "toolTipText" : qsTr("Transilvania"),
         "x" : "0.443",
         "y" : "0.396"
      },
      {
         "pixmapfile" : "romania/maramures.png",
         //: Historical Province of Romania: Maramureș
         "toolTipText" : qsTr("Maramureș"),
         "x" : "0.386",
         "y" : "0.111"
      },
      {
         "pixmapfile" : "romania/crisana.png",
         //: Historical Province of Romania: Crișana
         "toolTipText" : qsTr("Crișana"),
         "x" : "0.193",
         "y" : "0.290"
      },
      {
         "pixmapfile" : "romania/banat.png",
         //: Historical Province of Romania: Banat
         "toolTipText" : qsTr("Banat"),
         "x" : "0.128",
         "y" : "0.617"
      }
   ]
}
