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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Nagoya Castle, Aichi Prefecture, Japan.")
   property var levels: [
      {
         "pixmapfile" : "image/Nagoya_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Nagoya_0.png",
         "x" : "0.731",
         "y" : "0.35",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Nagoya_1.png",
         "x" : "0.76",
         "y" : "0.721",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Nagoya_2.png",
         "x" : "0.213",
         "y" : "0.543",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Nagoya_3.png",
         "x" : "0.669",
         "y" : "0.117",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Nagoya_4.png",
         "x" : "0.515",
         "y" : "0.522",
         "dropAreaSize" : "8"
      }
   ]
}
