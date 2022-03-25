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
   property string instruction: qsTr("Albrecht Dürer, Lion - 1494")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_d4.webp",
         "x" : "0.864",
         "y" : "0.831"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_c4.webp",
         "x" : "0.623",
         "y" : "0.831"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_b4.webp",
         "x" : "0.349",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_a4.webp",
         "x" : "0.13",
         "y" : "0.831"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_d3.webp",
         "x" : "0.839",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_c3.webp",
         "x" : "0.597",
         "y" : "0.594"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_b3.webp",
         "x" : "0.349",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_a3.webp",
         "x" : "0.13",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_d2.webp",
         "x" : "0.864",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_c2.webp",
         "x" : "0.623",
         "y" : "0.376"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_b2.webp",
         "x" : "0.374",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_a2.webp",
         "x" : "0.156",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_d1.webp",
         "x" : "0.864",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_c1.webp",
         "x" : "0.647",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_b1.webp",
         "x" : "0.4",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_a1.webp",
         "x" : "0.156",
         "y" : "0.138"
      }
   ]
}
