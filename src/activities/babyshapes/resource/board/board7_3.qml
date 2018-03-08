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
   property string instruction: qsTr("Vincent van Gogh, Bedroom in Arles - 1888")
   property var levels: [
	  {
          "pixmapfile" : "image/Van_Gogh_0011_background.png",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_5.png",
          "dropAreaSize" : "10",
          "x" : "0.695",
          "y" : "0.54"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_4.png",
          "dropAreaSize" : "10",
          "x" : "0.673",
          "y" : "0.068"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_3.png",
          "dropAreaSize" : "10",
          "x" : "0.491",
          "y" : "0.14"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_1.png",
          "dropAreaSize" : "10",
          "x" : "0.25",
          "y" : "0.434"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_2.png",
          "dropAreaSize" : "10",
          "x" : "0.086",
          "y" : "0.61"
      }
   ]
}
