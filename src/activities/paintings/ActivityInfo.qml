/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (bruno.coudoin@gcompris.net) (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com>  (Qt Quick port)
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
 
import GCompris 1.0

ActivityInfo {
  name: "paintings/Paintings.qml"
  difficulty: 1
  icon: "paintings/paintings.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Assemble the puzzle")
  //: Help title
  description: qsTr("Drag and Drop the items to rebuild the original paintings")
  // intro: "Catch and drop each piece on the points."
  //: Help goal
  goal: qsTr("Spatial representation")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation: movement, drag and drop")
  //: Help manual
  manual: qsTr("Drag the image parts from the box on the left to create a painting on the main board.")
  section: "puzzle"
  createdInVersion: 5000
}
