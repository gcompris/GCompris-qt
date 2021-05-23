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
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Tower Bridge in London")
   property var levels: [
      {
         "pixmapfile" : "image/TowerBridgeLondon_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/TowerBridgeLondon_0.png",
         "x" : "0.487",
         "y" : "0.365",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TowerBridgeLondon_1.png",
         "x" : "0.774",
         "y" : "0.206",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TowerBridgeLondon_2.png",
         "x" : "0.382",
         "y" : "0.709",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TowerBridgeLondon_3.png",
         "x" : "0.844",
         "y" : "0.565",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TowerBridgeLondon_4.png",
         "x" : "0.226",
         "y" : "0.668",
         "dropAreaSize" : "8"
      }
   ]
}
