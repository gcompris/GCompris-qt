/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "babymatch/Babymatch.qml"
  difficulty: 1
  icon: "babymatch/babymatch.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Matching items")
  //: Help title
  description: qsTr("Drag and drop the items to match them.")
//  intro: "Drag and drop the objects matching the pictures"
  //: Help goal
  goal: qsTr("Motor coordination. Conceptual matching.")
  //: Help prerequisite
  prerequisite: qsTr("Cultural references.")
  //: Help manual
  manual: qsTr("In the main board area, a set of objects is displayed. In the side panel, another set of objects is shown. Each object in the side panel corresponds logically to one object in the main board area. Drag each object from the side panel to the correct spot in the main area.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move the selection cursor through the panel items and board spots") + ("</li><li>") +
          qsTr("Space: select an item in the list, and place it on a spot. If there is nothing selected in the list, remove item from selected spot") + ("</li><li>") +
          qsTr("Tab: toggle navigation between the panel and the board without any other action") + ("</li><li>") +
          qsTr("Delete or Backspace: remove item from selected spot") + ("</li><li>") +
          qsTr("Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "reading vocabulary"
  createdInVersion: 4000
}
