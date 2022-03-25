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
   property string instruction: qsTr("The Lady and the Unicorn - XVe century")
   property var levels: [
	  {
          "pixmapfile" : "image/lady_unicorn_background.webp",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/lady_unicorn_5.webp",
          "dropAreaSize" : "10",
          "x" : "0.07",
          "y" : "0.818"
      },
      {
          "pixmapfile" : "image/lady_unicorn_4.webp",
          "dropAreaSize" : "10",
          "x" : "0.256",
          "y" : "0.666"
      },
      {
          "pixmapfile" : "image/lady_unicorn_2.webp",
          "dropAreaSize" : "10",
          "x" : "0.462",
          "y" : "0.553"
      },
      {
          "pixmapfile" : "image/lady_unicorn_3.webp",
          "dropAreaSize" : "10",
          "x" : "0.724",
          "y" : "0.883"
      },
      {
          "pixmapfile" : "image/lady_unicorn_1.webp",
          "dropAreaSize" : "10",
          "x" : "0.877",
          "y" : "0.039"
      }
   ]
}
