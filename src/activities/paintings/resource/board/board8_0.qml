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
   property string instruction: qsTr("Utagawa Hiroshige, The Benzaiten Shrine at Inokashira in Snow - 1760-70")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_d4.webp",
         "x" : "0.841",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_c4.webp",
         "x" : "0.623",
         "y" : "0.798"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_b4.webp",
         "x" : "0.374",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_a4.webp",
         "x" : "0.129",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_d3.webp",
         "x" : "0.866",
         "y" : "0.609"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_c3.webp",
         "x" : "0.623",
         "y" : "0.607"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_b3.webp",
         "x" : "0.373",
         "y" : "0.63"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_a3.webp",
         "x" : "0.155",
         "y" : "0.609"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_d2.webp",
         "x" : "0.866",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_c2.webp",
         "x" : "0.623",
         "y" : "0.412"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_b2.webp",
         "x" : "0.348",
         "y" : "0.412"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_a2.webp",
         "x" : "0.129",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_d1.webp",
         "x" : "0.841",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_c1.webp",
         "x" : "0.598",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_b1.webp",
         "x" : "0.348",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HiroshigeInokashiraSnow_a1.webp",
         "x" : "0.129",
         "y" : "0.197"
      }
   ]
}
