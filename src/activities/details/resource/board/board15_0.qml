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
   property string instruction: qsTr("Courtyard of the Museum of Louvre, and its pyramid")
   property var levels: [
      {
         "pixmapfile" : "image/Louvre_2007_02_24_c_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Louvre_2007_02_24_c_0.png",
         "x" : "0.9",
         "y" : "0.495",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Louvre_2007_02_24_c_1.png",
         "x" : "0.494",
         "y" : "0.509",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Louvre_2007_02_24_c_2.png",
         "x" : "0.164",
         "y" : "0.437",
         "dropAreaSize" : "8"
      }
   ]
}
