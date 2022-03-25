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
   property string instruction: qsTr("Katsushika Hokusai, Oiran and Kamuro")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/HokusaiOiranKamuro_b3.webp",
         "x" : "0.602",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/HokusaiOiranKamuro_a3.webp",
         "x" : "0.416",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/HokusaiOiranKamuro_b2.webp",
         "x" : "0.602",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/HokusaiOiranKamuro_a2.webp",
         "x" : "0.416",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/HokusaiOiranKamuro_b1.webp",
         "x" : "0.602",
         "y" : "0.242"
      },
      {
         "pixmapfile" : "image/HokusaiOiranKamuro_a1.webp",
         "x" : "0.416",
         "y" : "0.242"
      }
   ]
}
