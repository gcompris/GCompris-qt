/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
   property string instruction: qsTr("Eilean Donan castle")
   property var levels: [
      {
         "pixmapfile" : "image/EilanDonanCastle_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/EilanDonanCastle_0.webp",
         "x" : "0.566",
         "y" : "0.327",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/EilanDonanCastle_1.webp",
         "x" : "0.825",
         "y" : "0.174",
         "dropAreaSize" : "8"
      }
   ]
}
