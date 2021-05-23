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
   property int numberOfSubLevel: 3
   property string instruction: qsTr("Aviation")
   property var levels: [
      {
          "pixmapfile": "images/Eole.svg",
          "x": "0.25",
          "y": "0.2",
          "width": 0.4,
          "height": 0.2
      },
      {
          "pixmapfile": "images/wright_flyer.svg",
          "x": 0.5,
          "y": 0.65,
          "width": 0.4,
          "height": 0.2
      },
      {
          "pixmapfile": "images/bleriot.svg",
          "x": 0.75,
          "y": 0.2,
          "width": 0.4,
          "height": 0.2
      },
      {
		  "text": qsTr("1880 Clement Ader's Eole"),
		  "x": "0.25",
		  "y": 0.4,
		  "width": "0.4",
          "height": "0.15",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1903 The Wright brothers' Flyer III"),
          "x": 0.5,
		  "y": 0.85,
		  "width": "0.4",
          "height": "0.15",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1909 Louis Bleriot crosses the English Channel"),
		  "x": "0.75",
		  "y": 0.4,
		  "width": "0.4",
          "height": "0.15",
		  "type": "DisplayText"
      }
   ]
}
