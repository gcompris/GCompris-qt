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
   property string instruction: qsTr("Tux and the apple tree")
   property var levels: [
      {
          "pixmapfile": "images/chronos-tuxtree3.svg",
          "x": "0.25",
          "y": "0.65",
          "width": 0.4,
          "height": 0.25
      },
      {
          "pixmapfile": "images/chronos-tuxtree2.svg",
          "x": "0.75",
          "y": "0.2",
          "width": 0.4,
          "height": 0.25
      },
      {
          "pixmapfile": "images/chronos-tuxtree4.svg",
          "x": "0.75",
          "y": "0.65",
          "width": 0.4,
          "height": 0.25
      },
      {
          "pixmapfile": "images/chronos-tuxtree1.svg",
          "x": "0.25",
          "y": "0.2",
          "width": 0.4,
          "height": 0.25
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
