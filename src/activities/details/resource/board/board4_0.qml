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
   property string instruction: qsTr("Vincent van Gogh, Painter on His Way to Work - 1888")
   property var levels: [
      {
         "pixmapfile" : "image/VincentVanGogh0013_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0013_0.webp",
         "x" : "0.501",
         "y" : "0.32",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0013_1.webp",
         "x" : "0.859",
         "y" : "0.828",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0013_2.webp",
         "x" : "0.67",
         "y" : "0.22",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0013_3.webp",
         "x" : "0.396",
         "y" : "0.268",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0013_4.webp",
         "x" : "0.212",
         "y" : "0.44",
         "dropAreaSize" : "8"
      }
   ]
}
