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
   property string instruction: qsTr("The 4 Seasons")
   property var levels: [
      {
          "pixmapfile": "images/autumn.svg",
          "x": 0.25,
          "y": 0.65,
          "width": 0.4,
          "height": 0.25
      },
      {
          "pixmapfile": "images/summer.svg",
          "x": 0.75,
          "y": 0.2,
          "width": 0.4,
          "height": 0.25
      },
      {
          "pixmapfile": "images/spring.svg",
          "x": 0.25,
          "y": 0.2,
          "width": 0.4,
          "height": 0.25
      },
      {
          "pixmapfile": "images/winter.svg",
          "x": 0.75,
          "y": 0.65,
          "width": 0.4,
          "height": 0.25
      },
      {
		  "text": qsTr("Spring"),
		  "x": "0.25",
		  "y": 0.4,
		  "width": "0.4",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Summer"),
		  "x": "0.75",
		  "y": 0.4,
		  "width": "0.4",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Autumn"),
		  "x": "0.25",
		  "y": 0.85,
		  "width": "0.4",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Winter"),
		  "x": "0.75",
		  "y": 0.85,
		  "width": "0.4",
          "height": 0.1,
		  "type": "DisplayText"
      }
   ]
}
