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
   property string instruction: qsTr("Vincent van Gogh, The Night Café - 1888")
   property var levels: [
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_0.png",
         "x" : "0.328",
         "y" : "0.124",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_1.png",
         "x" : "0.606",
         "y" : "0.538",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_2.png",
         "x" : "0.675",
         "y" : "0.356",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_3.png",
         "x" : "0.808",
         "y" : "0.29",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_4.png",
         "x" : "0.166",
         "y" : "0.354",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_5.png",
         "x" : "0.278",
         "y" : "0.258",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_6.png",
         "x" : "0.915",
         "y" : "0.944",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Van_Gogh_The_Night_Cafe_7.png",
         "x" : "0.42",
         "y" : "0.262",
         "dropAreaSize" : "8"
      }
   ]
}
