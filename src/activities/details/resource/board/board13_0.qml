/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

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
