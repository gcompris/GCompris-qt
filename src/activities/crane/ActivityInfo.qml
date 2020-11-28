/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
