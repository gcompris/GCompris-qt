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
  name: "babymatch/Babymatch.qml"
  difficulty: 1
  icon: "babymatch/babymatch.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Matching Items")
  description: qsTr("Drag and Drop the items to make them match")
  goal: qsTr("Motor coordination. Conceptual matching.")
  prerequisite: qsTr("Mouse manipulation: movement, drag and drop. Cultural references.")
  manual: qsTr("In the main board area, a set of objects is displayed. In the vertical box (at the left of the main board) another set of objects is shown, each object in the group on the left matching exactly one object in the main board area. This game challenges you to find the logical link between these objects. How do they fit together? Drag each object to the correct red space in the main area.")
  credit: ""
  section: "/discovery/miscellaneous"
}
