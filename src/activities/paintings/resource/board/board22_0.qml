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
   property string instruction: qsTr("Vincent Van Gogh, Village Street in Auvers - 1890")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/gogh_auvert_2.webp",
         "x" : "0.489",
         "y" : "0.224"
      },
      {
         "pixmapfile" : "image/gogh_auvert_6.webp",
         "x" : "0.774",
         "y" : "0.681"
      },
      {
         "pixmapfile" : "image/gogh_auvert_5.webp",
         "x" : "0.489",
         "y" : "0.681"
      },
      {
         "pixmapfile" : "image/gogh_auvert_1.webp",
         "x" : "0.204",
         "y" : "0.224"
      },
      {
         "pixmapfile" : "image/gogh_auvert_4.webp",
         "x" : "0.204",
         "y" : "0.681"
      },
      {
         "pixmapfile" : "image/gogh_auvert_3.webp",
         "x" : "0.774",
         "y" : "0.224"
      }
   ]
}
