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
   property string instruction: qsTr("Mary Cassatt, Summertime - 1894")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/cassat_summertime_2.webp",
         "x" : "0.496",
         "y" : "0.244"
      },
      {
         "pixmapfile" : "image/cassat_summertime_4.webp",
         "x" : "0.211",
         "y" : "0.671"
      },
      {
         "pixmapfile" : "image/cassat_summertime_6.webp",
         "x" : "0.779",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "image/cassat_summertime_5.webp",
         "x" : "0.496",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "image/cassat_summertime_1.webp",
         "x" : "0.211",
         "y" : "0.244"
      },
      {
         "pixmapfile" : "image/cassat_summertime_3.webp",
         "x" : "0.779",
         "y" : "0.244"
      }
   ]
}
