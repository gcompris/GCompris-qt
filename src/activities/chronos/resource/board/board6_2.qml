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
   property string instruction: qsTr("Cars")
   property var levels: [
      {
          "pixmapfile": "images/bolle1878.svg",
          "x": "0.25",
          "y": "0.2",
          "width": 0.4,
          "height": 0.2
      },
      {
          "pixmapfile": "images/fardier.svg",
          "x": 0.5,
          "y": 0.65,
          "width": 0.4,
          "height": 0.2
      },
      {
          "pixmapfile": "images/benz1885.svg",
          "x": 0.75,
          "y": 0.2,
          "width": 0.4,
          "height": 0.2
      },
      {
          "text": qsTr("1878 Amédée Bollée's La Mancelle"),
		  "x": "0.25",
		  "y": 0.4,
		  "width": "0.4",
          "height": 0.15,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1769 Cugnot's fardier"),
		  "x": "0.5",
		  "y": 0.85,
		  "width": "0.4",
          "height": 0.15,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1885 The first petrol car by Benz"),
		  "x": "0.75",
		  "y": 0.4,
		  "width": "0.4",
          "height": 0.15,
		  "type": "DisplayText"
      }
   ]
}
