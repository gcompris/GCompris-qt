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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("The 4 Seasons")
   property var levels: [
      {
          "pixmapfile": "images/autumn.svg",
          "x": 0.25,
          "y": 0.7,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/summer.svg",
          "x": 0.75,
          "y": 0.25,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/spring.svg",
          "x": 0.25,
          "y": 0.25,
          "width": 0.4,
          "height": 0.319
      },
      {
          "pixmapfile": "images/winter.svg",
          "x": 0.75,
          "y": 0.7,
          "width": 0.4,
          "height": 0.319
      },
      {
		  "text": qsTr("Spring"),
		  "x": "0.25",
		  "y": 0.25,
		  "width": "0.4",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Summer"),
		  "x": "0.75",
		  "y": 0.25,
		  "width": "0.4",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Autumn"),
		  "x": "0.25",
		  "y": 0.7,
		  "width": "0.4",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Winter"),
		  "x": "0.75",
		  "y": 0.7,
		  "width": "0.4",
		  "type": "DisplayText"
      }
   ]
}
