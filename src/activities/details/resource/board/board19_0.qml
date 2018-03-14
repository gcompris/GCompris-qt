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
   property string instruction: qsTr("Taj Mahal, Agra, India")
   property var levels: [
      {
         "pixmapfile" : "image/TajMahal_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/TajMahal_0.png",
         "x" : "0.499",
         "y" : "0.1",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_1.png",
         "x" : "0.893",
         "y" : "0.252",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_2.png",
         "x" : "0.507",
         "y" : "0.534",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_3.png",
         "x" : "0.351",
         "y" : "0.33",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_4.png",
         "x" : "0.626",
         "y" : "0.32",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_5.png",
         "x" : "0.501",
         "y" : "0.256",
         "dropAreaSize" : "8"
      }
   ]
}
