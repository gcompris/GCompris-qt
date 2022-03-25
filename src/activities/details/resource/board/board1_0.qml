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
   property string instruction: qsTr("Vincent van Gogh, Entrance Hall of Saint-Paul Hospital - 1889")
   property var levels: [
      {
         "pixmapfile" : "image/VincentVanGogh0012_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0012_0.webp",
         "x" : "0.543",
         "y" : "0.102",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0012_1.webp",
         "x" : "0.601",
         "y" : "0.468",
         "dropAreaSize" : "8"
      }
   ]
}
