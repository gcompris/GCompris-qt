/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Moonwalker")
   property var levels: [
      {
          "pixmapfile": "images/4.png",
          "x": "0.7",
          "y": "0.7",
          "soundFile": "sound/2.$CA"
      },
      {
          "pixmapfile": "images/3.png",
          "x": "0.3",
          "y": "0.7",
          "soundFile": "sound/3.$CA"
      },
      {
          "pixmapfile": "images/2.png",
          "x": "0.7",
          "y": "0.25",
          "soundFile": "sound/2.$CA"
      },
      {
          "pixmapfile": "images/1.png",
          "x": "0.3",
          "y": "0.25",
          "soundFile": "sound/1.$CA"
      },
      {
		  "text": qsTr("1"),
		  "x": "0.3",
		  "y": 0.25,
		  "width": "0.2",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("2"),
		  "x": "0.7",
		  "y": 0.25,
		  "width": "0.2",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("3"),
		  "x": "0.3",
		  "y": 0.7,
		  "width": "0.2",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("4"),
		  "x": "0.7",
		  "y": 0.7,
		  "width": "0.2",
		  "type": "DisplayText"
      }
   ]
}
