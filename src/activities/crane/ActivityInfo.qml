/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
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
  name: "crane/Crane.qml"
  difficulty: 2
  icon: "crane/crane.svg"
  author: "Stefan Toncu &lt;stefan.toncu29@gmail.com&gt;"
  //: Activity title
  title: qsTr("Build the same model")
  //: Help title
  description: qsTr("Drive the crane and copy the model.")
  //intro: " Click on each item in turn, in the blue frame, and move them to reproduce the pattern from the pink frame."
  //: Help goal
  goal: qsTr("Practice motor-coordination.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse/keyboard manipulation.")
  //: Help manual
  manual: qsTr("Move the items in the blue frame to match their position in the model frame. To select an item, just click on it. Next to the crane, you will find four arrows that let you move the selected item. You can also swipe up/down/left/right to move the selected item.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move the selected item") + ("</li><li>") +
          qsTr("Space or Enter or Tab: select the next item") + ("</li></ul>")
  credit: ""
  section: "puzzle"
  createdInVersion: 7000
  levels: "1,2,3,4"
}
