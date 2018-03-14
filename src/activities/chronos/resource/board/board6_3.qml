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
   property string instruction: qsTr("Cars")
   property var levels: [
      {
          "pixmapfile": "images/renault1899.svg",
          "x": 0.2,
          "y": 0.55,
          "width": 0.4,
          "height": 0.305
      },
      {
          "pixmapfile": "images/lancia1923.svg",
          "x": 0.5,
          "y": 0.9,
          "width": 0.4,
          "height": 0.16
      },
      {
          "pixmapfile": "images/1955ds19.svg",
          "x": 0.75,
          "y": 0.55,
          "width": 0.4,
          "height": 0.19
      },
      {
		  "text": qsTr("1899 Renault voiturette"),
		  "x": "0.25",
		  "y": 0.2,
		  "width": "0.4",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1923 Lancia Lambda"),
		  "x": "0.5",
		  "y": 0.75,
		  "width": "0.4",
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("1955 Citroën DS 19"),
          "x": 0.75,
		  "y": 0.21,
          "width": 0.4,
          "type": "DisplayText"
      }
   ]
}
