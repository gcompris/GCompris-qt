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
   property string instruction: qsTr("The Lady and the Unicorn - XVe century")
   property var levels: [
	  {
          "pixmapfile" : "image/lady_unicorn_background.png",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/lady_unicorn_5.png",
          "dropAreaSize" : "10",
          "x" : "0.07",
          "y" : "0.818"
      },
      {
          "pixmapfile" : "image/lady_unicorn_4.png",
          "dropAreaSize" : "10",
          "x" : "0.256",
          "y" : "0.666"
      },
      {
          "pixmapfile" : "image/lady_unicorn_2.png",
          "dropAreaSize" : "10",
          "x" : "0.462",
          "y" : "0.553"
      },
      {
          "pixmapfile" : "image/lady_unicorn_3.png",
          "dropAreaSize" : "10",
          "x" : "0.724",
          "y" : "0.883"
      },
      {
          "pixmapfile" : "image/lady_unicorn_1.png",
          "dropAreaSize" : "10",
          "x" : "0.877",
          "y" : "0.039"
      }
   ]
}
