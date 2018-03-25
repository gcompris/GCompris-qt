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
   property string instruction: qsTr("Katsushika Hokusa, Poppies - 1833-1834")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_e5.png",
         "x" : "0.848",
         "y" : "0.825"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_d5.png",
         "x" : "0.665",
         "y" : "0.825"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_c5.png",
         "x" : "0.496",
         "y" : "0.842"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_b5.png",
         "x" : "0.311",
         "y" : "0.842"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_a5.png",
         "x" : "0.127",
         "y" : "0.825"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_e4.png",
         "x" : "0.865",
         "y" : "0.671"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_d4.png",
         "x" : "0.702",
         "y" : "0.671"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_c4.png",
         "x" : "0.498",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_b4.png",
         "x" : "0.31",
         "y" : "0.689"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_a4.png",
         "x" : "0.147",
         "y" : "0.654"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_e3.png",
         "x" : "0.865",
         "y" : "0.515"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_d3.png",
         "x" : "0.702",
         "y" : "0.515"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_c3.png",
         "x" : "0.498",
         "y" : "0.496"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_b3.png",
         "x" : "0.31",
         "y" : "0.498"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_a3.png",
         "x" : "0.147",
         "y" : "0.496"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_e2.png",
         "x" : "0.848",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_d2.png",
         "x" : "0.683",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_c2.png",
         "x" : "0.516",
         "y" : "0.323"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_b2.png",
         "x" : "0.329",
         "y" : "0.305"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_a2.png",
         "x" : "0.147",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_e1.png",
         "x" : "0.865",
         "y" : "0.169"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_d1.png",
         "x" : "0.702",
         "y" : "0.169"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_c1.png",
         "x" : "0.516",
         "y" : "0.15"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_b1.png",
         "x" : "0.311",
         "y" : "0.15"
      },
      {
         "pixmapfile" : "image/HokusaiPoppies_a1.png",
         "x" : "0.127",
         "y" : "0.169"
      }
   ]
}
