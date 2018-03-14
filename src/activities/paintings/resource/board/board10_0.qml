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
   property string instruction: qsTr("Katsushika Hokusai, Viewing Sunset over the Ryogoku Bridge from the Ommaya Embankment - 1830")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HokusaiBridge_e4.png",
         "x" : "0.869",
         "y" : "0.798"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_d4.png",
         "x" : "0.687",
         "y" : "0.798"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_c4.png",
         "x" : "0.497",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_b4.png",
         "x" : "0.311",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_a4.png",
         "x" : "0.125",
         "y" : "0.798"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_e3.png",
         "x" : "0.869",
         "y" : "0.585"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_d3.png",
         "x" : "0.687",
         "y" : "0.607"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_c3.png",
         "x" : "0.479",
         "y" : "0.63"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_b3.png",
         "x" : "0.309",
         "y" : "0.609"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_a3.png",
         "x" : "0.145",
         "y" : "0.585"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_e2.png",
         "x" : "0.869",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_d2.png",
         "x" : "0.687",
         "y" : "0.412"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_c2.png",
         "x" : "0.479",
         "y" : "0.39"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_b2.png",
         "x" : "0.291",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_a2.png",
         "x" : "0.125",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_e1.png",
         "x" : "0.869",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_d1.png",
         "x" : "0.705",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_c1.png",
         "x" : "0.517",
         "y" : "0.174"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_b1.png",
         "x" : "0.311",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_a1.png",
         "x" : "0.125",
         "y" : "0.197"
      }
   ]
}
