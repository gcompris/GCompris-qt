/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (New images and coordinates)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
   property string instruction: qsTr("The 4 Seasons")
   property var levels: [
      {
          "pixmapfile": "images/seasons-autumn.svg",
          "x": 0.25,
          "y": 0.65,
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/seasons-summer.svg",
          "x": 0.75,
          "y": 0.2,
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/seasons-spring.svg",
          "x": 0.25,
          "y": 0.2,
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/seasons-winter.svg",
          "x": 0.75,
          "y": 0.65,
          "width": 0.4,
          "height": 0.3
      },
      {
		  "text": qsTr("Spring"),
		  "x": "0.25",
		  "y": 0.4,
		  "width": "0.4",
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Summer"),
		  "x": "0.75",
		  "y": 0.4,
		  "width": "0.4",
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Autumn"),
		  "x": "0.25",
		  "y": 0.85,
		  "width": "0.4",
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Winter"),
		  "x": "0.75",
		  "y": 0.85,
		  "width": "0.4",
          "height": 0.075,
		  "type": "DisplayText"
      }
   ]
}
