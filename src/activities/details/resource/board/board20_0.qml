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
   property string instruction: qsTr("Castle Neuschwanstein at Schwangau, Bavaria, Germany")
   property var levels: [
      {
         "pixmapfile" : "image/Neuschwanstein_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_0.png",
         "x" : "0.876",
         "y" : "0.578",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_1.png",
         "x" : "0.759",
         "y" : "0.537",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_2.png",
         "x" : "0.674",
         "y" : "0.348",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_3.png",
         "x" : "0.557",
         "y" : "0.465",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_4.png",
         "x" : "0.553",
         "y" : "0.735",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_5.png",
         "x" : "0.434",
         "y" : "0.537",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_6.png",
         "x" : "0.325",
         "y" : "0.265",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_7.png",
         "x" : "0.254",
         "y" : "0.11",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_8.png",
         "x" : "0.165",
         "y" : "0.535",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_9.png",
         "x" : "0.059",
         "y" : "0.499",
         "dropAreaSize" : "8"
      }
   ]
}
