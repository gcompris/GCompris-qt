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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Pieter Brugel, The Harvesters - 1565")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/PieterBruegel_d4.png",
         "x" : "0.859",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/PieterBruegel_c4.png",
         "x" : "0.622",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/PieterBruegel_b4.png",
         "x" : "0.353",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/PieterBruegel_a4.png",
         "x" : "0.137",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/PieterBruegel_d3.png",
         "x" : "0.835",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/PieterBruegel_c3.png",
         "x" : "0.621",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/PieterBruegel_b3.png",
         "x" : "0.402",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/PieterBruegel_a3.png",
         "x" : "0.162",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/PieterBruegel_d2.png",
         "x" : "0.835",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "image/PieterBruegel_c2.png",
         "x" : "0.621",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/PieterBruegel_b2.png",
         "x" : "0.377",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "image/PieterBruegel_a2.png",
         "x" : "0.137",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/PieterBruegel_d1.png",
         "x" : "0.835",
         "y" : "0.138"
      },
      {
         "pixmapfile" : "image/PieterBruegel_c1.png",
         "x" : "0.621",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/PieterBruegel_b1.png",
         "x" : "0.402",
         "y" : "0.138"
      },
      {
         "pixmapfile" : "image/PieterBruegel_a1.png",
         "x" : "0.162",
         "y" : "0.163"
      }
   ]
}
