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
   property string instruction: qsTr("Cars")
   property var levels: [
      {
          "pixmapfile": "images/renault_voiturette.svg",
          "x": 0.25,
          "y": 0.2,
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/lancia_lambda.svg",
          "x": 0.75,
          "y": 0.2,
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/citroen_DS19.svg",
          "x": 0.5,
          "y": 0.65,
          "width": 0.4,
          "height": 0.3
      },
      {
		  "text": qsTr("1898 Renault voiturette"),
		  "x": 0.25,
		  "y": 0.4,
		  "width": 0.4,
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1923 Lancia Lambda"),
		  "x": 0.75,
		  "y": 0.4,
		  "width": 0.4,
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1955 Citroën DS 19"),
          "x": 0.5,
		  "y": 0.85,
          "width": 0.4,
          "height": 0.075,
          "type": "DisplayText"
      }
   ]
}
