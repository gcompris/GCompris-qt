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
   property string instruction: qsTr("Pieter Brugel, The Harvesters - 1565")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/PieterBruegel_d4.webp",
         "x" : "0.859",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/PieterBruegel_c4.webp",
         "x" : "0.622",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/PieterBruegel_b4.webp",
         "x" : "0.353",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/PieterBruegel_a4.webp",
         "x" : "0.137",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/PieterBruegel_d3.webp",
         "x" : "0.835",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/PieterBruegel_c3.webp",
         "x" : "0.621",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/PieterBruegel_b3.webp",
         "x" : "0.402",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/PieterBruegel_a3.webp",
         "x" : "0.162",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/PieterBruegel_d2.webp",
         "x" : "0.835",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "image/PieterBruegel_c2.webp",
         "x" : "0.621",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/PieterBruegel_b2.webp",
         "x" : "0.377",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "image/PieterBruegel_a2.webp",
         "x" : "0.137",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/PieterBruegel_d1.webp",
         "x" : "0.835",
         "y" : "0.138"
      },
      {
         "pixmapfile" : "image/PieterBruegel_c1.webp",
         "x" : "0.621",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/PieterBruegel_b1.webp",
         "x" : "0.402",
         "y" : "0.138"
      },
      {
         "pixmapfile" : "image/PieterBruegel_a1.webp",
         "x" : "0.162",
         "y" : "0.163"
      }
   ]
}
