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
   property string instruction: qsTr("Bazille, The Ramparts at Aigues-Mortes - 1867")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/bazille_rampart_4.webp",
         "x" : "0.212",
         "y" : "0.634"
      },
      {
         "pixmapfile" : "image/bazille_rampart_1.webp",
         "x" : "0.212",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/bazille_rampart_3.webp",
         "x" : "0.791",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/bazille_rampart_5.webp",
         "x" : "0.501",
         "y" : "0.634"
      },
      {
         "pixmapfile" : "image/bazille_rampart_2.webp",
         "x" : "0.501",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/bazille_rampart_6.webp",
         "x" : "0.791",
         "y" : "0.634"
      }
   ]
}
