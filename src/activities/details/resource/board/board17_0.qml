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
   property string instruction: qsTr("Windmill in Sønderho, Fanø, Denmark")
   property var levels: [
      {
         "pixmapfile" : "image/FanoeWindmill_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/FanoeWindmill_0.png",
         "x" : "0.679",
         "y" : "0.324",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/FanoeWindmill_1.png",
         "x" : "0.162",
         "y" : "0.612",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/FanoeWindmill_2.png",
         "x" : "0.703",
         "y" : "0.812",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/FanoeWindmill_3.png",
         "x" : "0.372",
         "y" : "0.696",
         "dropAreaSize" : "8"
      }
   ]
}
