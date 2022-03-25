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
   property string instruction: qsTr("Egeskov Castle, Denmark")
   property var levels: [
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_0.webp",
         "x" : "0.766",
         "y" : "0.197",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_1.webp",
         "x" : "0.762",
         "y" : "0.816",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_2.webp",
         "x" : "0.669",
         "y" : "0.209",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_3.webp",
         "x" : "0.568",
         "y" : "0.452",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_4.webp",
         "x" : "0.524",
         "y" : "0.101",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_5.webp",
         "x" : "0.278",
         "y" : "0.161",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_6.webp",
         "x" : "0.524",
         "y" : "0.81",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/EgeskovSlotSpejling_7.webp",
         "x" : "0.416",
         "y" : "0.412",
         "dropAreaSize" : "8"
      }
   ]
}
