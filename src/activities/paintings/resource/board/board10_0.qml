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
   property string instruction: qsTr("Katsushika Hokusai, Viewing Sunset over the Ryogoku Bridge from the Ommaya Embankment - 1830")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HokusaiBridge_e4.webp",
         "x" : "0.869",
         "y" : "0.798"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_d4.webp",
         "x" : "0.687",
         "y" : "0.798"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_c4.webp",
         "x" : "0.497",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_b4.webp",
         "x" : "0.311",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_a4.webp",
         "x" : "0.125",
         "y" : "0.798"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_e3.webp",
         "x" : "0.869",
         "y" : "0.585"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_d3.webp",
         "x" : "0.687",
         "y" : "0.607"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_c3.webp",
         "x" : "0.479",
         "y" : "0.63"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_b3.webp",
         "x" : "0.309",
         "y" : "0.609"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_a3.webp",
         "x" : "0.145",
         "y" : "0.585"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_e2.webp",
         "x" : "0.869",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_d2.webp",
         "x" : "0.687",
         "y" : "0.412"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_c2.webp",
         "x" : "0.479",
         "y" : "0.39"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_b2.webp",
         "x" : "0.291",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_a2.webp",
         "x" : "0.125",
         "y" : "0.388"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_e1.webp",
         "x" : "0.869",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_d1.webp",
         "x" : "0.705",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_c1.webp",
         "x" : "0.517",
         "y" : "0.174"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_b1.webp",
         "x" : "0.311",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "image/HokusaiBridge_a1.webp",
         "x" : "0.125",
         "y" : "0.197"
      }
   ]
}
