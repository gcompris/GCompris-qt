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
   property string instruction: qsTr("Nagoya Castle, Aichi Prefecture, Japan.")
   property var levels: [
      {
         "pixmapfile" : "image/Nagoya_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Nagoya_0.webp",
         "x" : "0.731",
         "y" : "0.35",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Nagoya_1.webp",
         "x" : "0.76",
         "y" : "0.721",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Nagoya_2.webp",
         "x" : "0.213",
         "y" : "0.543",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Nagoya_3.webp",
         "x" : "0.669",
         "y" : "0.117",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Nagoya_4.webp",
         "x" : "0.515",
         "y" : "0.522",
         "dropAreaSize" : "8"
      }
   ]
}
