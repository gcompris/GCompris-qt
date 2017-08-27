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
  name: "details/Details.qml"
  difficulty: 1
  icon: "details/details.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Find the details")
  //: Help title
  description: qsTr("Drag and Drop the shapes on their respective targets")
//  intro: "Slide the images on their respective targets"
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Complete the puzzle by dragging each piece from the set of pieces on the left, to the matching space in the puzzle.")
  credit: qsTr("The images are from Wikimedia Commons.")
  section: "discovery"
  createdInVersion: 4000
}
