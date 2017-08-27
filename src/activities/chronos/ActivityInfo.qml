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
  name: "chronos/Chronos.qml"
  difficulty: 1
  icon: "chronos/chronos.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Chronos")
  //: Help title
  description: qsTr("Drag and Drop the items to organize the story")
//  intro: "Slide the pictures into the order that tells the story"
  //: Help goal
  goal: qsTr("Sort the pictures into the order that tells the story")
  //: Help prerequisite
  prerequisite: qsTr("Tell a short story")
  //: Help manual
  manual: qsTr("Pick from the pictures on the left and put them on the red dots")
  credit: qsTr("Moon photo is copyright NASA. The space sounds come from Tuxpaint and Vegastrike which are released under the GPL license. The transportation images are copyright Franck Doucet. Dates of Transportation are based on those found in &lt;http://www.wikipedia.org&gt;.")
  section: "discovery"
  createdInVersion: 4000
}
