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
   property string instruction: qsTr("Ambrosius Bosschaert the Elder, Flower Still Life - 1614")
   property var levels: [
	  {
          "pixmapfile" : "image/Bosschaert_04_background.png",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_6.png",
          "dropAreaSize" : "10",
          "x" : "0.432",
          "y" : "0.732"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_5.png",
          "dropAreaSize" : "10",
          "x" : "0.553",
          "y" : "0.3"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_4.png",
          "dropAreaSize" : "10",
          "x" : "0.481",
          "y" : "0.486"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_3.png",
          "dropAreaSize" : "10",
          "x" : "0.217",
          "y" : "0.233"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_2.png",
          "dropAreaSize" : "10",
          "x" : "0.167",
          "y" : "0.582"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_1.png",
          "dropAreaSize" : "10",
          "x" : "0.653",
          "y" : "0.749"
      }
   ]
}
