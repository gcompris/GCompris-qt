/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
   property string instruction: qsTr("Vincent van Gogh, The Church at Auvers-sur-Oise - 1890")
   property var levels: [
      {
         "pixmapfile" : "image/Eglise_dAuvers-sur-Oise_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Eglise_dAuvers-sur-Oise_0.webp",
         "x" : "0.181",
         "y" : "0.78",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Eglise_dAuvers-sur-Oise_1.webp",
         "x" : "0.577",
         "y" : "0.178",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Eglise_dAuvers-sur-Oise_2.webp",
         "x" : "0.091",
         "y" : "0.56",
         "dropAreaSize" : "8"
      }
   ]
}
