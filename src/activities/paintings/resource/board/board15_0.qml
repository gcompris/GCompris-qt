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
   property string instruction: qsTr("Giovanni Bellini, La Pala di Pesaro - 1475-85")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_c3.webp",
         "x" : "0.814",
         "y" : "0.705"
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_b3.webp",
         "x" : "0.499",
         "y" : "0.727"
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_a3.webp",
         "x" : "0.182",
         "y" : "0.705"
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_c2.webp",
         "x" : "0.814",
         "y" : "0.474"
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_b2.webp",
         "x" : "0.532",
         "y" : "0.498"
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_a2.webp",
         "x" : "0.215",
         "y" : "0.474"
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_c1.webp",
         "x" : "0.781",
         "y" : "0.264"
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_b1.webp",
         "x" : "0.466",
         "y" : "0.264"
      },
      {
         "pixmapfile" : "image/PalaDiPesaro_a1.webp",
         "x" : "0.182",
         "y" : "0.264"
      }
   ]
}
