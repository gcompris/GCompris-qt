/* GCompris
 *
 * SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Horia PELLE <horricane@gmail.com>
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Historical regions of Romania")
   property var levels: [
      {
         "pixmapfile" : "romania/romania-historical.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "romania/oltenia.svgz",
         //: Historical Region of Romania: Oltenia
         "toolTipText" : qsTr("Oltenia"),
         "x" : "0.3569",
         "y" : "0.763"
      },
      {
         "pixmapfile" : "romania/muntenia.svgz",
         //: Historical Region of Romania: Muntenia
         "toolTipText" : qsTr("Muntenia"),
         "x" : "0.6241",
         "y" : "0.7439"
      },
      {
         "pixmapfile" : "romania/northern_dobruja.svgz",
         //: Historical Region of Romania: Northern Dobruja
         "toolTipText" : qsTr("Northern Dobruja"),
         "x" : "0.8609",
         "y" : "0.7549"
      },
      {
         "pixmapfile" : "romania/moldavia.svgz",
         //: Historical Region of Romania: Moldavia
         "toolTipText" : qsTr("Moldavia"),
         "x" : "0.6884",
         "y" : "0.3262"
      },
      {
         "pixmapfile" : "romania/bukovina.svgz",
         //: Historical Region of Romania: Bukovina
         "toolTipText" : qsTr("Bukovina"),
         "x" : "0.5696",
         "y" : "0.186"
      },
      {
         "pixmapfile" : "romania/transylvania.svgz",
         //: Historical Region of Romania: Transylvania
         "toolTipText" : qsTr("Transylvania"),
         "x" : "0.4423",
         "y" : "0.4026"
      },
      {
         "pixmapfile" : "romania/maramures.svgz",
         //: Historical Region of Romania: Maramureș
         "toolTipText" : qsTr("Maramureș"),
         "x" : "0.3668",
         "y" : "0.1464"
      },
      {
         "pixmapfile" : "romania/crisana.svgz",
         //: Historical Region of Romania: Crișana
         "toolTipText" : qsTr("Crișana"),
         "x" : "0.2039",
         "y" : "0.3292"
      },
      {
         "pixmapfile" : "romania/banat.svgz",
         //: Historical Region of Romania: Banat
         "toolTipText" : qsTr("Banat"),
         "x" : "0.141",
         "y" : "0.6106"
      }
   ]
}
