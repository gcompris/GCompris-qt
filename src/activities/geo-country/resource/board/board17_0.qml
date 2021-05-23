/* GCompris
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Rolandas Jakštys <rolasorama@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Cultural regions of Lithuania")
   property var levels: [
      {
         "pixmapfile" : "lithuania/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "lithuania/aukstaitija.png",
         //: Cultural region of Lithuania: Aukštaitija
         "toolTipText" : qsTr("Aukštaitija"),
         "x" : "0.648",
         "y" : "0.380"
      },
      {
         "pixmapfile" : "lithuania/dzukija.png",
         //: Cultural region of Lithuania: Dzūkija
         "toolTipText" : qsTr("Dzūkija"),
         "x" : "0.622",
         "y" : "0.725"
      },
      {
         "pixmapfile" : "lithuania/lithuania_minor.png",
         //: Cultural region of Lithuania: Lithuania Minor
         "toolTipText" : qsTr("Lithuania Minor"),
         "x" : "0.180",
         "y" : "0.400"
      },
      {
         "pixmapfile" : "lithuania/samogitia.png",
         //: Cultural region of Lithuania: Samogitia
         "toolTipText" : qsTr("Samogitia"),
         "x" : "0.268",
         "y" : "0.310"
      },
      {
         "pixmapfile" : "lithuania/sudovia.png",
         //: Cultural region of Lithuania: Suvalkija
         "toolTipText" : qsTr("Suvalkija"),
         "x" : "0.420",
         "y" : "0.675"
      }
   ]
}
