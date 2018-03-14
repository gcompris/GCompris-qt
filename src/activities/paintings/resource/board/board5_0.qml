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
   property string instruction: qsTr("Katsushika Hokusai, Woman holding a fan")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_c3.png",
         "x" : "0.627",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_b3.png",
         "x" : "0.484",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_a3.png",
         "x" : "0.355",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_c2.png",
         "x" : "0.64",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_b2.png",
         "x" : "0.499",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_a2.png",
         "x" : "0.355",
         "y" : "0.498"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_c1.png",
         "x" : "0.64",
         "y" : "0.212"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_b1.png",
         "x" : "0.499",
         "y" : "0.242"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_a1.png",
         "x" : "0.355",
         "y" : "0.212"
      }
   ]
}
