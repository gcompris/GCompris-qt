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
   property string instruction: qsTr("Panorama of Château de Chenonceau, Indre-et-Loire, France.")
   property var levels: [
      {
         "pixmapfile" : "image/Chenonceau_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Chenonceau_0.webp",
         "x" : "0.199",
         "y" : "0.459",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Chenonceau_1.webp",
         "x" : "0.318",
         "y" : "0.421",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Chenonceau_2.webp",
         "x" : "0.469",
         "y" : "0.579",
         "dropAreaSize" : "8"
      }
   ]
}
