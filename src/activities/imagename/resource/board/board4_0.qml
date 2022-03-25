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
   property var levels: [
      {
          "pixmapfile": "images/apple.svg",
          "x": "0.2",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/tree.svg",
          "x": "0.5",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/bicycle.svg",
          "x": "0.8",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/car.svg",
          "x": "0.2",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/carrot.svg",
          "x": "0.5",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/rape.svg",
          "x": "0.8",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
		  "text": qsTr("apple"),
		  "x": "0.2",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("tree"),
		  "x": "0.5",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("bicycle"),
		  "x": "0.8",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("car"),
		  "x": "0.2",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("carrot"),
		  "x": "0.5",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("grater"),
		  "x": "0.8",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      }
   ]
}
