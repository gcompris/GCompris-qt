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
   property int numberOfSubLevel: 4
   property string instruction: qsTr("Place each object on the date it was invented.")
   property var levels: [
      {
          "pixmapfile": "images/fardier.svg",
          "x": 0.75,
          "y": 0.2,
          "width": 0.4,
          "height": 0.2
      },
      {
          "pixmapfile": "images/st_rocket.svg",
          "x": 0.25,
          "y": 0.2,
          "width": 0.4,
          "height": 0.2
      },
      {
		  "text": qsTr("1829 Stephenson's Rocket Steam locomotive"),
          "x": 0.25,
		  "y": 0.4,
          "width": 0.4,
          "height": 0.15,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1769 Cugnot's fardier"),
          "x": 0.75,
		  "y": 0.4,
          "width": 0.4,
          "height": 0.15,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Transportation"),
          "x": 0.5,
		  "y": 0.85,
          "width": 0.3,
          "height": 0.1,
		  "type": "DisplayText"
      }
   ]
}
