/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "paintings/Paintings.qml"
  difficulty: 1
  icon: "paintings/shapegame.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Assemble the puzzle")
  description: qsTr("Drag and Drop the items to rebuild the original paintings")
  goal: qsTr("Spatial representation")
  prerequisite: qsTr("Mouse-manipulation: movement, drag and drop")
  manual: qsTr("Drag the image parts from the box on the left to create a painting on the main board.")
  credit: ""
  section: "/puzzle"
}
