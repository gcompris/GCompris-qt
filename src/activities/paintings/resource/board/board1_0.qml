/* GCompris
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
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
import QtQuick 2.0

QtObject {
   property int numberOfSubLevel: 12
   property string instruction: qsTr("Edgar Degas, The Dancing Class - 1873-75")
   property variant levels : [
      {
         "pixmapfile" : "image/bg.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/degas_class-dance_6.png",
         "x" : "0.657",
         "y" : "0.807"
      },
      {
         "pixmapfile" : "image/degas_class-dance_5.png",
         "x" : "0.382",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "image/degas_class-dance_4.png",
         "x" : "0.618",
         "y" : "0.486"
      },
      {
         "pixmapfile" : "image/degas_class-dance_3.png",
         "x" : "0.343",
         "y" : "0.448"
      },
      {
         "pixmapfile" : "image/degas_class-dance_2.png",
         "x" : "0.658",
         "y" : "0.162"
      },
      {
         "pixmapfile" : "image/degas_class-dance_1.png",
         "x" : "0.383",
         "y" : "0.166"
      }
   ]
}
