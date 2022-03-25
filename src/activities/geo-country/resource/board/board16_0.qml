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
import QtQuick 2.12

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
         "x" : "0.3551",
         "y" : "0.7682"
      },
      {
         "pixmapfile" : "romania/muntenia.svgz",
         //: Historical Region of Romania: Muntenia
         "toolTipText" : qsTr("Muntenia"),
         "x" : "0.6223",
         "y" : "0.7485"
      },
      {
         "pixmapfile" : "romania/northern_dobruja.svgz",
         //: Historical Region of Romania: Northern Dobruja
         "toolTipText" : qsTr("Northern Dobruja"),
         "x" : "0.8591",
         "y" : "0.7599"
      },
      {
         "pixmapfile" : "romania/moldavia.svgz",
         //: Historical Region of Romania: Moldavia
         "toolTipText" : qsTr("Moldavia"),
         "x" : "0.6866",
         "y" : "0.3177"
      },
      {
         "pixmapfile" : "romania/bukovina.svgz",
         //: Historical Region of Romania: Bukovina
         "toolTipText" : qsTr("Bukovina"),
         "x" : "0.5678",
         "y" : "0.1731"
      },
      {
         "pixmapfile" : "romania/transylvania.svgz",
         //: Historical Region of Romania: Transylvania
         "toolTipText" : qsTr("Transylvania"),
         "x" : "0.4406",
         "y" : "0.3965"
      },
      {
         "pixmapfile" : "romania/maramures.svgz",
         //: Historical Region of Romania: Maramureș
         "toolTipText" : qsTr("Maramureș"),
         "x" : "0.365",
         "y" : "0.1322"
      },
      {
         "pixmapfile" : "romania/crisana.svgz",
         //: Historical Region of Romania: Crișana
         "toolTipText" : qsTr("Crișana"),
         "x" : "0.2021",
         "y" : "0.3208"
      },
      {
         "pixmapfile" : "romania/banat.svgz",
         //: Historical Region of Romania: Banat
         "toolTipText" : qsTr("Banat"),
         "x" : "0.1392",
         "y" : "0.611"
      }
   ]
}
