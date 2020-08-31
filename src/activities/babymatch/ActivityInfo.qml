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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "babymatch/Babymatch.qml"
  difficulty: 1
  icon: "babymatch/babymatch.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Matching Items")
  //: Help title
  description: qsTr("Drag and Drop the items to match them.")
//  intro: "Drag and drop the objects matching the pictures"
  //: Help goal
  goal: qsTr("Motor coordination. Conceptual matching.")
  //: Help prerequisite
  prerequisite: qsTr("Cultural references.")
  //: Help manual
  manual: qsTr("In the main board area, a set of objects is displayed. In the side panel, another set of objects is shown. Each object in the side panel corresponds logically to one object in the main board area. Drag each object from the side panel to the correct spot in the main area.")
  credit: ""
  section: "reading vocabulary"
  createdInVersion: 4000
}
