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
   property string instruction: qsTr("Courtyard of the Museum of Louvre, and its pyramid")
   property var levels: [
      {
         "pixmapfile" : "image/Louvre_2007_02_24_c_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Louvre_2007_02_24_c_0.png",
         "x" : "0.9",
         "y" : "0.495",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Louvre_2007_02_24_c_1.png",
         "x" : "0.494",
         "y" : "0.509",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Louvre_2007_02_24_c_2.png",
         "x" : "0.164",
         "y" : "0.437",
         "dropAreaSize" : "8"
      }
   ]
}
