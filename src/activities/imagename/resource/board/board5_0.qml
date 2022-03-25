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
          "pixmapfile": "images/pencil.svg",
          "x": "0.2",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/postcard.svg",
          "x": "0.5",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/tree.svg",
          "x": "0.8",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/star.svg",
          "x": "0.2",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/truck.svg",
          "x": "0.5",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/minivan.svg",
          "x": "0.8",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
		  "text": qsTr("pencil"),
		  "x": "0.2",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("postcard"),
		  "x": "0.5",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("tree"),
		  "x": "0.8",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("star"),
		  "x": "0.2",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("truck"),
		  "x": "0.5",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("van"),
		  "x": "0.8",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      }
   ]
}
