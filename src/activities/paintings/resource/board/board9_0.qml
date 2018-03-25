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
   property string instruction: qsTr("Utagawa Hiroshige, Horse-mackerel and Prawn - 1840")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_d4.png",
         "x" : "0.853",
         "y" : "0.83"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_c4.png",
         "x" : "0.626",
         "y" : "0.853"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_b4.png",
         "x" : "0.37",
         "y" : "0.83"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_a4.png",
         "x" : "0.115",
         "y" : "0.83"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_d3.png",
         "x" : "0.853",
         "y" : "0.594"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_c3.png",
         "x" : "0.6",
         "y" : "0.619"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_b3.png",
         "x" : "0.343",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_a3.png",
         "x" : "0.115",
         "y" : "0.594"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_d2.png",
         "x" : "0.853",
         "y" : "0.376"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_c2.png",
         "x" : "0.6",
         "y" : "0.376"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_b2.png",
         "x" : "0.368",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_a2.png",
         "x" : "0.142",
         "y" : "0.375"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_d1.png",
         "x" : "0.878",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_c1.png",
         "x" : "0.627",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_b1.png",
         "x" : "0.368",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_a1.png",
         "x" : "0.142",
         "y" : "0.163"
      }
   ]
}
