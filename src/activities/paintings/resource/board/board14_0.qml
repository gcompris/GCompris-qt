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
   property string instruction: qsTr("Leonardo da Vinci, Mona Lisa - 1503-19")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/MonaLisa_d3.webp",
         "x" : "0.667",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "image/MonaLisa_c3.webp",
         "x" : "0.568",
         "y" : "0.814"
      },
      {
         "pixmapfile" : "image/MonaLisa_b3.webp",
         "x" : "0.442",
         "y" : "0.814"
      },
      {
         "pixmapfile" : "image/MonaLisa_a3.webp",
         "x" : "0.328",
         "y" : "0.814"
      },
      {
         "pixmapfile" : "image/MonaLisa_d2.webp",
         "x" : "0.667",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/MonaLisa_c2.webp",
         "x" : "0.568",
         "y" : "0.499"
      },
      {
         "pixmapfile" : "image/MonaLisa_b2.webp",
         "x" : "0.453",
         "y" : "0.499"
      },
      {
         "pixmapfile" : "image/MonaLisa_a2.webp",
         "x" : "0.34",
         "y" : "0.531"
      },
      {
         "pixmapfile" : "image/MonaLisa_d1.webp",
         "x" : "0.656",
         "y" : "0.214"
      },
      {
         "pixmapfile" : "image/MonaLisa_c1.webp",
         "x" : "0.556",
         "y" : "0.18"
      },
      {
         "pixmapfile" : "image/MonaLisa_b1.webp",
         "x" : "0.442",
         "y" : "0.18"
      },
      {
         "pixmapfile" : "image/MonaLisa_a1.webp",
         "x" : "0.328",
         "y" : "0.214"
      }
   ]
}
