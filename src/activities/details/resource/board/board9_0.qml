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
   property string instruction: qsTr("Notre Dame de Paris cathedral on the Île de la Cité in Paris, France.")
   property var levels: [
      {
         "pixmapfile" : "image/NDP_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/NDP_0.webp",
         "x" : "0.508",
         "y" : "0.65",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/NDP_1.webp",
         "x" : "0.499",
         "y" : "0.357",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/NDP_2.webp",
         "x" : "0.286",
         "y" : "0.888",
         "dropAreaSize" : "8"
      }
   ]
}
