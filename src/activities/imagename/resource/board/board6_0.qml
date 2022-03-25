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
          "pixmapfile": "images/castle.svg",
          "x": "0.2",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/crown.svg",
          "x": "0.5",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/sailingboat.svg",
          "x": "0.8",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/windflag5.svg",
          "x": "0.2",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/raquette.svg",
          "x": "0.5",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/football.svg",
          "x": "0.8",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
		  "text": qsTr("castle"),
		  "x": "0.2",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("crown"),
		  "x": "0.5",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("sailing boat"),
		  "x": "0.8",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("flag"),
		  "x": "0.2",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("racket"),
		  "x": "0.5",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("ball"),
		  "x": "0.8",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      }
   ]
}
