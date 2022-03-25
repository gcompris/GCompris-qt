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
   property int numberOfSubLevel: 4
   property string instruction: qsTr("Paul Gauguin, Arearea - 1892")
   property var levels: [
	  {
          "pixmapfile" : "image/Paul_Gauguin_006_background.webp",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/Paul_Gauguin_006_chien.webp",
          "dropAreaSize" : "10",
          "x" : "0.278",
          "y" : "0.807"
      },
      {
          "pixmapfile" : "image/Paul_Gauguin_006_jeunes_filles.webp",
          "dropAreaSize" : "10",
          "x" : "0.666",
          "y" : "0.46"
      },
      {
          "pixmapfile" : "image/Paul_Gauguin_006_statue.webp",
          "dropAreaSize" : "10",
          "x" : "0.19",
          "y" : "0.133"
      }
   ]
}
