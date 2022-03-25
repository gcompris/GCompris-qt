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
   property string instruction: qsTr("Katsushika Hokusai, The Great Wave off Kanagawa - 1823-1829")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/GreatWave_d3.webp",
         "x" : "0.847",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/GreatWave_c3.webp",
         "x" : "0.64",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/GreatWave_b3.webp",
         "x" : "0.404",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/GreatWave_a3.webp",
         "x" : "0.172",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "image/GreatWave_d2.webp",
         "x" : "0.847",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "image/GreatWave_c2.webp",
         "x" : "0.64",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/GreatWave_b2.webp",
         "x" : "0.404",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "image/GreatWave_a2.webp",
         "x" : "0.172",
         "y" : "0.527"
      },
      {
         "pixmapfile" : "image/GreatWave_d1.webp",
         "x" : "0.847",
         "y" : "0.212"
      },
      {
         "pixmapfile" : "image/GreatWave_c1.webp",
         "x" : "0.617",
         "y" : "0.242"
      },
      {
         "pixmapfile" : "image/GreatWave_b1.webp",
         "x" : "0.355",
         "y" : "0.212"
      },
      {
         "pixmapfile" : "image/GreatWave_a1.webp",
         "x" : "0.147",
         "y" : "0.242"
      }
   ]
}
