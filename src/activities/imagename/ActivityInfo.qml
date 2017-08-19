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
  name: "imagename/Imagename.qml"
  difficulty: 3
  icon: "imagename/imagename.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Image Name")
  //: Help title
  description: qsTr("Drag and Drop each item above its name")
//  intro: "Drag and drop each item above its name."
  //: Help goal
  goal: qsTr("Vocabulary and reading")
  //: Help prerequisite
  prerequisite: qsTr("Reading")
  //: Help manual
  manual: qsTr("Drag each image from the (vertical) box on the left to its (corresponding) name on the right. Click the OK button to check your answer.")
  section: "reading"
  createdInVersion: 4000
}
