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
   property string instruction: qsTr("Moonwalker")
   property var levels: [
      {
          "pixmapfile": "images/4.png",
          "x": "0.75",
          "y": "0.65",
          "width": 0.4,
          "height": 0.25,
          "soundFile": "sound/2.$CA"
      },
      {
          "pixmapfile": "images/3.png",
          "x": "0.25",
          "y": "0.65",
          "width": 0.4,
          "height": 0.25,
          "soundFile": "sound/3.$CA"
      },
      {
          "pixmapfile": "images/2.png",
          "x": "0.75",
          "y": "0.2",
          "width": 0.4,
          "height": 0.25,
          "soundFile": "sound/2.$CA"
      },
      {
          "pixmapfile": "images/1.png",
          "x": "0.25",
          "y": "0.2",
          "width": 0.4,
          "height": 0.25,
          "soundFile": "sound/1.$CA"
      },
      {
		  "text": qsTr("1"),
		  "x": "0.25",
		  "y": 0.4,
		  "width": "0.1",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("2"),
		  "x": "0.75",
		  "y": 0.4,
		  "width": "0.1",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("3"),
		  "x": "0.25",
		  "y": 0.85,
		  "width": "0.1",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("4"),
		  "x": "0.75",
		  "y": 0.85,
		  "width": "0.1",
          "height": 0.1,
		  "type": "DisplayText"
      }
   ]
}
