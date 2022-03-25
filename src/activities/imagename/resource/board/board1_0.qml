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
   property string instruction: qsTr("Drag and Drop each item above its name")
   property var levels: [
      {
          "pixmapfile": "images/postpoint.svg",
          "x": "0.2",
          "y": "0.2",
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/sailingboat.svg",
          "x": "0.5",
          "y": "0.2",
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/lamp.svg",
          "x": "0.8",
          "y": "0.2",
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/postcard.svg",
          "x": "0.2",
          "y": "0.65",
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/fishingboat.svg",
          "x": "0.5",
          "y": "0.65",
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/light.svg",
          "x": "0.8",
          "y": "0.65",
          "height": 0.25,
          "width": 0.25
      },
      {
		  "text": qsTr("mail box"),
		  "x": "0.2",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("sailing boat"),
		  "x": "0.5",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("lamp"),
		  "x": "0.8",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("postcard"),
		  "x": "0.2",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("fishing boat"),
		  "x": "0.5",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("bulb"),
		  "x": "0.8",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      }
   ]
}
