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
   property string instruction: qsTr("Katsushika Hokusai, Woman holding a fan")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_c3.webp",
         "x" : "0.627",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_b3.webp",
         "x" : "0.484",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_a3.webp",
         "x" : "0.355",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_c2.webp",
         "x" : "0.64",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_b2.webp",
         "x" : "0.499",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_a2.webp",
         "x" : "0.355",
         "y" : "0.498"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_c1.webp",
         "x" : "0.64",
         "y" : "0.212"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_b1.webp",
         "x" : "0.499",
         "y" : "0.242"
      },
      {
         "pixmapfile" : "image/HokusaiWomanHoldingFan_a1.webp",
         "x" : "0.355",
         "y" : "0.212"
      }
   ]
}
