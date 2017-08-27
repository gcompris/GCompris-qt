/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
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
  name: "babymatch/Babymatch.qml"
  difficulty: 1
  icon: "babymatch/babymatch.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Matching Items")
  //: Help title
  description: qsTr("Drag and Drop the items to make them match")
//  intro: "Drag and drop the objects matching the pictures"
  //: Help goal
  goal: qsTr("Motor coordination. Conceptual matching.")
  //: Help prerequisite
  prerequisite: qsTr("Cultural references.")
  //: Help manual
  manual: qsTr("In the main board area, a set of objects is displayed. In the vertical box (at the left of the main board) another set of objects is shown, each object in the group on the left matching exactly one object in the main board area. This game challenges you to find the logical link between these objects. How do they fit together? Drag each object to the correct red space in the main area.")
  credit: ""
  section: "discovery"
  createdInVersion: 4000
}
