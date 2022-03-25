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
   property string instruction: qsTr("Pieter Bruegel the Elder, The peasants wedding - 1568")
   property var levels: [
	  {
          "pixmapfile" : "image/Pieter_Bruegel_background.webp",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/Pieter_Bruegel_service.webp",
          "dropAreaSize" : "10",
          "x" : "0.684",
          "y" : "0.628"
      },
      {
          "pixmapfile" : "image/Pieter_Bruegel_mur.webp",
          "dropAreaSize" : "10",
          "x" : "0.866",
          "y" : "0.143"
      },
      {
          "pixmapfile" : "image/Pieter_Bruegel_musicien.webp",
          "dropAreaSize" : "10",
          "x" : "0.257",
          "y" : "0.453"
      },
      {
          "pixmapfile" : "image/Pieter_Bruegel_fillette.webp",
          "dropAreaSize" : "10",
          "x" : "0.354",
          "y" : "0.87"
      }
   ]
}
