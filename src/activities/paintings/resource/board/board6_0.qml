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
   property string instruction: qsTr("Katsushika Hokusai, Ejiri in Suruga Province - 1830-1833")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/EjiriSuruga_d3.webp",
         "x" : "0.846",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_c3.webp",
         "x" : "0.618",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_b3.webp",
         "x" : "0.38",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_a3.webp",
         "x" : "0.174",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_d2.webp",
         "x" : "0.823",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_c2.webp",
         "x" : "0.616",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_b2.webp",
         "x" : "0.405",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_a2.webp",
         "x" : "0.174",
         "y" : "0.498"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_d1.webp",
         "x" : "0.823",
         "y" : "0.242"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_c1.webp",
         "x" : "0.616",
         "y" : "0.212"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_b1.webp",
         "x" : "0.405",
         "y" : "0.212"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_a1.webp",
         "x" : "0.174",
         "y" : "0.212"
      }
   ]
}
