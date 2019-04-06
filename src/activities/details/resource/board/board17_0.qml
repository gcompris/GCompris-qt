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
   property string instruction: qsTr("Windmill in Sønderho, Fanø, Denmark")
   property var levels: [
      {
         "pixmapfile" : "image/FanoeWindmill_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/FanoeWindmill_0.png",
         "x" : "0.679",
         "y" : "0.324",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/FanoeWindmill_1.png",
         "x" : "0.162",
         "y" : "0.612",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/FanoeWindmill_2.png",
         "x" : "0.703",
         "y" : "0.812",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/FanoeWindmill_3.png",
         "x" : "0.372",
         "y" : "0.696",
         "dropAreaSize" : "8"
      }
   ]
}
