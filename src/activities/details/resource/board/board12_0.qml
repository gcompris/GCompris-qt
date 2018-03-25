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
   property string instruction: qsTr("Sydney Opera House, Australia")
   property var levels: [
      {
         "pixmapfile" : "image/OperaSidney_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/OperaSidney_0.png",
         "x" : "0.243",
         "y" : "0.543",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/OperaSidney_1.png",
         "x" : "0.399",
         "y" : "0.596",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/OperaSidney_2.png",
         "x" : "0.471",
         "y" : "0.375",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/OperaSidney_3.png",
         "x" : "0.579",
         "y" : "0.58",
         "dropAreaSize" : "8"
      }
   ]
}
