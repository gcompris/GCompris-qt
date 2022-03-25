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
   property string instruction: qsTr("Giuseppe Arcimboldo, Spring - 1573")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/Arcimboldo_Spring_b3.webp",
         "x" : "0.615",
         "y" : "0.762"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Spring_a3.webp",
         "x" : "0.405",
         "y" : "0.735"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Spring_b2.webp",
         "x" : "0.59",
         "y" : "0.498"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Spring_a2.webp",
         "x" : "0.379",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Spring_b1.webp",
         "x" : "0.59",
         "y" : "0.231"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Spring_a1.webp",
         "x" : "0.379",
         "y" : "0.259"
      }
   ]
}
