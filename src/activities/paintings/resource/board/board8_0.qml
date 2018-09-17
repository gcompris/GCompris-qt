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
   property string instruction: qsTr("Utagawa Hiroshige, The Benzaiten Shrine at Inokashira in Snow - 1760-70")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_d4.png",
         "x" : "0.841",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_c4.png",
         "x" : "0.623",
         "y" : "0.798"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_b4.png",
         "x" : "0.374",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_a4.png",
         "x" : "0.129",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_d3.png",
         "x" : "0.866",
         "y" : "0.609"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_c3.png",
         "x" : "0.623",
         "y" : "0.607"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_b3.png",
         "x" : "0.373",
         "y" : "0.63"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_a3.png",
         "x" : "0.155",
         "y" : "0.609"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_d2.png",
         "x" : "0.866",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_c2.png",
         "x" : "0.623",
         "y" : "0.412"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_b2.png",
         "x" : "0.348",
         "y" : "0.412"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_a2.png",
         "x" : "0.129",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_d1.png",
         "x" : "0.841",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_c1.png",
         "x" : "0.598",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_b1.png",
         "x" : "0.348",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_a1.png",
         "x" : "0.129",
         "y" : "0.197"
      }
   ]
}
