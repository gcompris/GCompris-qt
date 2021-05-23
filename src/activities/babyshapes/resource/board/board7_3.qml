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
   property string instruction: qsTr("Vincent van Gogh, Bedroom in Arles - 1888")
   property var levels: [
	  {
          "pixmapfile" : "image/Van_Gogh_0011_background.png",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_5.png",
          "dropAreaSize" : "10",
          "x" : "0.695",
          "y" : "0.54"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_4.png",
          "dropAreaSize" : "10",
          "x" : "0.673",
          "y" : "0.068"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_3.png",
          "dropAreaSize" : "10",
          "x" : "0.491",
          "y" : "0.14"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_1.png",
          "dropAreaSize" : "10",
          "x" : "0.25",
          "y" : "0.434"
      },
      {
          "pixmapfile" : "image/Van_Gogh_0011_2.png",
          "dropAreaSize" : "10",
          "x" : "0.086",
          "y" : "0.61"
      }
   ]
}
