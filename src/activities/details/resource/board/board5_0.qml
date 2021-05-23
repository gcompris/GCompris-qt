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
   property string instruction: qsTr("Vincent van Gogh, The Harvest - 1888")
   property var levels: [
      {
         "pixmapfile" : "image/VincentVanGogh0019_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_0.png",
         "x" : "0.393",
         "y" : "0.348",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_1.png",
         "x" : "0.784",
         "y" : "0.498",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_2.png",
         "x" : "0.5",
         "y" : "0.464",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_3.png",
         "x" : "0.13",
         "y" : "0.346",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_4.png",
         "x" : "0.685",
         "y" : "0.604",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_5.png",
         "x" : "0.226",
         "y" : "0.212",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_6.png",
         "x" : "0.908",
         "y" : "0.21",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_7.png",
         "x" : "0.292",
         "y" : "0.484",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/VincentVanGogh0019_8.png",
         "x" : "0.337",
         "y" : "0.27",
         "dropAreaSize" : "8"
      }
   ]
}
