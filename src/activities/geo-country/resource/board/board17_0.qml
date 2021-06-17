/* GCompris
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Rolandas Jakštys <rolasorama@gmail.com>
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Cultural regions of Lithuania")
   property var levels: [
      {
         "pixmapfile" : "lithuania/lithuania-cultural.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "lithuania/aukstaitija.svgz",
         //: Cultural region of Lithuania: Aukštaitija
         "toolTipText" : qsTr("Aukštaitija"),
         "x" : "0.6749",
         "y" : "0.3687"
      },
      {
         "pixmapfile" : "lithuania/dzukija.svgz",
         //: Cultural region of Lithuania: Dzūkija
         "toolTipText" : qsTr("Dzūkija"),
         "x" : "0.6455",
         "y" : "0.7288"
      },
      {
         "pixmapfile" : "lithuania/lithuania_minor.svgz",
         //: Cultural region of Lithuania: Lithuania Minor
         "toolTipText" : qsTr("Lithuania Minor"),
         "x" : "0.1544",
         "y" : "0.3906"
      },
      {
         "pixmapfile" : "lithuania/samogitia.svgz",
         //: Cultural region of Lithuania: Samogitia
         "toolTipText" : qsTr("Samogitia"),
         "x" : "0.2502",
         "y" : "0.2945"
      },
      {
         "pixmapfile" : "lithuania/suvalkija.svgz",
         //: Cultural region of Lithuania: Suvalkija
         "toolTipText" : qsTr("Suvalkija"),
         "x" : "0.4217",
         "y" : "0.6759"
      }
   ]
}
