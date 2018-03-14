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
   property string instruction: qsTr("Leonardo da Vinci, Mona Lisa - 1503-19")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/MonaLisa_d3.png",
         "x" : "0.667",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "image/MonaLisa_c3.png",
         "x" : "0.568",
         "y" : "0.814"
      },
      {
         "pixmapfile" : "image/MonaLisa_b3.png",
         "x" : "0.442",
         "y" : "0.814"
      },
      {
         "pixmapfile" : "image/MonaLisa_a3.png",
         "x" : "0.328",
         "y" : "0.814"
      },
      {
         "pixmapfile" : "image/MonaLisa_d2.png",
         "x" : "0.667",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/MonaLisa_c2.png",
         "x" : "0.568",
         "y" : "0.499"
      },
      {
         "pixmapfile" : "image/MonaLisa_b2.png",
         "x" : "0.453",
         "y" : "0.499"
      },
      {
         "pixmapfile" : "image/MonaLisa_a2.png",
         "x" : "0.34",
         "y" : "0.531"
      },
      {
         "pixmapfile" : "image/MonaLisa_d1.png",
         "x" : "0.656",
         "y" : "0.214"
      },
      {
         "pixmapfile" : "image/MonaLisa_c1.png",
         "x" : "0.556",
         "y" : "0.18"
      },
      {
         "pixmapfile" : "image/MonaLisa_b1.png",
         "x" : "0.442",
         "y" : "0.18"
      },
      {
         "pixmapfile" : "image/MonaLisa_a1.png",
         "x" : "0.328",
         "y" : "0.214"
      }
   ]
}
