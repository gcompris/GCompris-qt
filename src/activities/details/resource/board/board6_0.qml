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
   property string instruction: qsTr("Vincent van Gogh, Cafe Terrace at Night - 1888")
   property var levels: [
      {
         "pixmapfile" : "image/Gogh4_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Gogh4_0.png",
         "x" : "0.753",
         "y" : "0.594",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_1.png",
         "x" : "0.234",
         "y" : "0.776",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_2.png",
         "x" : "0.633",
         "y" : "0.618",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_3.png",
         "x" : "0.459",
         "y" : "0.922",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_4.png",
         "x" : "0.511",
         "y" : "0.112",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_5.png",
         "x" : "0.88",
         "y" : "0.532",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_6.png",
         "x" : "0.783",
         "y" : "0.198",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_7.png",
         "x" : "0.229",
         "y" : "0.444",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_8.png",
         "x" : "0.579",
         "y" : "0.794",
         "dropAreaSize" : "8"
      }
   ]
}
