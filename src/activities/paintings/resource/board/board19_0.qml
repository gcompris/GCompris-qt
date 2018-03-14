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
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Wassily Kandinsky, Composition VIII - 1923")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/kandinky_8.png",
         "x" : "0.85",
         "y" : "0.618"
      },
      {
         "pixmapfile" : "image/kandinky_7.png",
         "x" : "0.642",
         "y" : "0.618"
      },
      {
         "pixmapfile" : "image/kandinky_6.png",
         "x" : "0.376",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "image/kandinky_5.png",
         "x" : "0.138",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "image/kandinky_4.png",
         "x" : "0.85",
         "y" : "0.228"
      },
      {
         "pixmapfile" : "image/kandinky_3.png",
         "x" : "0.642",
         "y" : "0.228"
      },
      {
         "pixmapfile" : "image/kandinky_2.png",
         "x" : "0.405",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/kandinky_1.png",
         "x" : "0.167",
         "y" : "0.283"
      }
   ]
}
