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
   property string instruction: qsTr("Giuseppe Arcimboldo, The Librarian - 1566")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_c3.webp",
         "x" : "0.625",
         "y" : "0.735"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_b3.webp",
         "x" : "0.498",
         "y" : "0.735"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_a3.webp",
         "x" : "0.372",
         "y" : "0.762"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_c2.webp",
         "x" : "0.638",
         "y" : "0.47"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_b2.webp",
         "x" : "0.499",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_a2.webp",
         "x" : "0.357",
         "y" : "0.498"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_c1.webp",
         "x" : "0.625",
         "y" : "0.231"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_b1.webp",
         "x" : "0.498",
         "y" : "0.259"
      },
      {
         "pixmapfile" : "image/Arcimboldo_Librarian_a1.webp",
         "x" : "0.373",
         "y" : "0.231"
      }
   ]
}
