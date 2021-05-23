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
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Taj Mahal, Agra, India")
   property var levels: [
      {
         "pixmapfile" : "image/TajMahal_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/TajMahal_0.png",
         "x" : "0.499",
         "y" : "0.1",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_1.png",
         "x" : "0.893",
         "y" : "0.252",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_2.png",
         "x" : "0.507",
         "y" : "0.534",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_3.png",
         "x" : "0.351",
         "y" : "0.33",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_4.png",
         "x" : "0.626",
         "y" : "0.32",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TajMahal_5.png",
         "x" : "0.501",
         "y" : "0.256",
         "dropAreaSize" : "8"
      }
   ]
}
