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
   property int numberOfSubLevel: 4
   property string instruction: qsTr("Place each image in the order and on the date it was invented.")
   property var levels: [
      {
          "pixmapfile": "images/fardier.svg",
          "x": 0.7,
          "y": 0.8,
          "width": 0.4,
          "height": 0.14
      },
      {
          "pixmapfile": "images/st_rocket.svg",
          "x": 0.25,
          "y": 0.55,
          "width": 0.4,
          "height": 0.308
      },
      {
		  "text": qsTr("1829 Stephenson's Rocket Steam locomotive"),
          "x": 0.24,
		  "y": 0.29,
          "width": 0.4,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1769 Cugnot's fardier"),
          "x": 0.75,
		  "y": 0.59,
          "width": 0.4,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("Transportation"),
          "x": 0.8,
		  "y": 0.3,
          "width": 0.3,
		  "type": "DisplayText"
      }
   ]
}
