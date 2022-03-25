/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

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
         "pixmapfile" : "image/HiroshigeHorsePrawns_d4.webp",
         "x" : "0.853",
         "y" : "0.83"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_c4.webp",
         "x" : "0.626",
         "y" : "0.853"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_b4.webp",
         "x" : "0.37",
         "y" : "0.83"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_a4.webp",
         "x" : "0.115",
         "y" : "0.83"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_d3.webp",
         "x" : "0.853",
         "y" : "0.594"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_c3.webp",
         "x" : "0.6",
         "y" : "0.619"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_b3.webp",
         "x" : "0.343",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_a3.webp",
         "x" : "0.115",
         "y" : "0.594"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_d2.webp",
         "x" : "0.853",
         "y" : "0.376"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_c2.webp",
         "x" : "0.6",
         "y" : "0.376"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_b2.webp",
         "x" : "0.368",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_a2.webp",
         "x" : "0.142",
         "y" : "0.375"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_d1.webp",
         "x" : "0.878",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_c1.webp",
         "x" : "0.627",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_b1.webp",
         "x" : "0.368",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/HiroshigeHorsePrawns_a1.webp",
         "x" : "0.142",
         "y" : "0.163"
      }
   ]
}
