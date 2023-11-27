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
   property string instruction: qsTr("Aviation")
   property var levels: [
      {
          "pixmapfile": "images/yeager_X1.svg",
          "x": 0.5,
          "y": 0.65,
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/lindbergh_spirit.svg",
          "x": 0.25,
          "y": 0.2,
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/boucher_C460.svg",
          "x": 0.75,
          "y": 0.2,
          "width": 0.4,
          "height": 0.3
      },
      {
		  "text": qsTr("1947 Chuck Yeager breaks the sound-barrier"),
		  "x": 0.5,
		  "y": 0.85,
		  "width": 0.4,
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1927 Charles Lindbergh crosses the Atlantic Ocean"),
		  "x": 0.25,
		  "y": 0.4,
		  "width": 0.4,
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1934 Hélène Boucher's speed record of 445km/h"),
		  "x": 0.75,
		  "y": 0.4,
		  "width": 0.4,
          "height": 0.075,
		  "type": "DisplayText"
      }
   ]
}
