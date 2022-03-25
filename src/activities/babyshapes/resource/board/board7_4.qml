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
   property string instruction: qsTr("Ambrosius Bosschaert the Elder, Flower Still Life - 1614")
   property var levels: [
	  {
          "pixmapfile" : "image/Bosschaert_04_background.webp",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_6.webp",
          "dropAreaSize" : "10",
          "x" : "0.432",
          "y" : "0.732"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_5.webp",
          "dropAreaSize" : "10",
          "x" : "0.553",
          "y" : "0.3"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_4.webp",
          "dropAreaSize" : "10",
          "x" : "0.481",
          "y" : "0.486"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_3.webp",
          "dropAreaSize" : "10",
          "x" : "0.217",
          "y" : "0.233"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_2.webp",
          "dropAreaSize" : "10",
          "x" : "0.167",
          "y" : "0.582"
      },
      {
          "pixmapfile" : "image/Bosschaert_04_1.webp",
          "dropAreaSize" : "10",
          "x" : "0.653",
          "y" : "0.749"
      }
   ]
}
